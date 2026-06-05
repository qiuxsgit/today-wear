import 'dart:async';

import '../api/api_exception.dart';
import '../api/outfit_api.dart';
import '../api/tag_api.dart';
import '../database/database.dart';
import 'log_service.dart';
import 'session_service.dart';
import 'sync_service.dart';

/// 读校验结论
enum VerCheckStatus {
  /// 未登录/未开同步/无 serverId/网络失败或超时——降级，直接用本地数据
  skipped,

  /// 服务端不更新（ver ≤ 本地）
  upToDate,

  /// 服务端更新且本地无未推送修改——已静默落库，调用方需重新读取本地数据
  refreshed,

  /// 服务端更新且本地 dirty——双端冲突，交用户裁决（remote 为最新云端数据）
  conflict,

  /// 云端已软删（outfit）——交用户裁决
  remoteDeleted,
}

/// outfit 读校验结果
class OutfitVerCheckResult {
  final VerCheckStatus status;
  final RemoteOutfit? remote;
  const OutfitVerCheckResult(this.status, [this.remote]);
}

/// tag 读校验结果
class TagVerCheckResult {
  final VerCheckStatus status;
  final RemoteTagFull? remote;
  const TagVerCheckResult(this.status, [this.remote]);
}

/// 记录级乐观锁读校验与冲突裁决。
///
/// 进详情页/点编辑标签前调用 check，按 spec：1.5 秒超时即降级渲染本地并记
/// 警告日志；404 同样降级。冲突与"云端已删"由 UI 层弹框，裁决动作回到本类。
class VerCheckService {
  VerCheckService._();
  static final VerCheckService instance = VerCheckService._();

  static const Duration _timeout = Duration(milliseconds: 1500);

  final AppDatabase _db = AppDatabase();
  final OutfitApi _outfitApi = OutfitApi();
  final TagApi _tagApi = TagApi();

  bool get _enabled =>
      SessionService.instance.isLoggedIn && SessionService.instance.syncEnabled;

  /// 进详情页前调用。按本地 outfit id 校验服务端版本。
  Future<OutfitVerCheckResult> checkOutfit(int localId) async {
    if (!_enabled) return const OutfitVerCheckResult(VerCheckStatus.skipped);
    final row = await _db.outfitDao.getOutfitByIdRaw(localId);
    if (row == null || row.serverId == null) {
      return const OutfitVerCheckResult(VerCheckStatus.skipped);
    }

    final RemoteOutfit? remote;
    try {
      remote =
          await _outfitApi.checkVer(row.serverId!, row.ver).timeout(_timeout);
    } on TimeoutException {
      LogService.instance.warn('VerCheck', 'outfit ver-check timeout (>1.5s)');
      return const OutfitVerCheckResult(VerCheckStatus.skipped);
    } on ApiException catch (e) {
      // 404（已不存在/无权）与网络失败均降级渲染本地（spec 边界）
      LogService.instance.warn('VerCheck', 'outfit ver-check failed: ${e.code}');
      return const OutfitVerCheckResult(VerCheckStatus.skipped);
    }

    if (remote == null) {
      return const OutfitVerCheckResult(VerCheckStatus.upToDate);
    }
    if (remote.isDeleted) {
      return OutfitVerCheckResult(VerCheckStatus.remoteDeleted, remote);
    }
    if (row.dirty == 1) {
      return OutfitVerCheckResult(VerCheckStatus.conflict, remote);
    }

    await SyncService.instance.applyRemoteOutfit(remote);
    return OutfitVerCheckResult(VerCheckStatus.refreshed, remote);
  }

  /// 冲突裁决：保留本机——把本地 base 提到服务端最新 ver，推送覆盖。
  Future<void> keepLocalOutfit(int localId, RemoteOutfit remote) async {
    await _db.outfitDao.setOutfitVer(localId, remote.ver);
    SyncService.instance.syncInBackground();
  }

  /// 冲突裁决：用云端——强制落库云端版本，清 dirty。
  Future<void> useCloudOutfit(RemoteOutfit remote) async {
    await SyncService.instance.applyRemoteOutfit(remote, force: true);
  }

  /// 云端已删裁决：恢复——以删除后的最新 ver 为 base 重新推送本机版本
  /// （服务端 PUT 整体替换会清软删、复活记录）。
  Future<void> restoreOutfit(int localId, RemoteOutfit remote) async {
    await _db.outfitDao.setOutfitVer(localId, remote.ver);
    SyncService.instance.syncInBackground();
  }

  /// 云端已删裁决：接受删除——本地同步删除。
  Future<void> acceptOutfitDeleted(RemoteOutfit remote) async {
    await SyncService.instance.applyRemoteOutfit(remote, force: true);
  }

  /// 点编辑标签前调用。
  Future<TagVerCheckResult> checkTag(int localTagId) async {
    if (!_enabled) return const TagVerCheckResult(VerCheckStatus.skipped);
    final row = await _db.tagDao.getTagById(localTagId);
    if (row == null || row.serverId == null) {
      return const TagVerCheckResult(VerCheckStatus.skipped);
    }

    final RemoteTagFull? remote;
    try {
      remote = await _tagApi.checkVer(row.serverId!, row.ver).timeout(_timeout);
    } on TimeoutException {
      LogService.instance.warn('VerCheck', 'tag ver-check timeout (>1.5s)');
      return const TagVerCheckResult(VerCheckStatus.skipped);
    } on ApiException catch (e) {
      // 标签为硬删除：404 即云端已删，按 spec 降级进入编辑（本地数据）
      LogService.instance.warn('VerCheck', 'tag ver-check failed: ${e.code}');
      return const TagVerCheckResult(VerCheckStatus.skipped);
    }

    if (remote == null) return const TagVerCheckResult(VerCheckStatus.upToDate);
    if (row.dirty == 1) {
      return TagVerCheckResult(VerCheckStatus.conflict, remote);
    }

    await _db.tagDao.upsertRemoteTag(
      serverId: remote.id,
      name: remote.name,
      color: remote.color,
      ver: remote.ver,
    );
    return TagVerCheckResult(VerCheckStatus.refreshed, remote);
  }

  /// 标签冲突裁决：保留本机。
  Future<void> keepLocalTag(int localTagId, RemoteTagFull remote) async {
    await _db.tagDao.setTagVer(localTagId, remote.ver);
    SyncService.instance.syncInBackground();
  }

  /// 标签冲突裁决：用云端。
  Future<void> useCloudTag(RemoteTagFull remote) async {
    await _db.tagDao.upsertRemoteTag(
      serverId: remote.id,
      name: remote.name,
      color: remote.color,
      ver: remote.ver,
    );
  }
}
