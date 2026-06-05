import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_exception.dart';
import '../api/media_api.dart';
import '../api/outfit_api.dart';
import '../api/tag_api.dart';
import '../api/gfs_uploader.dart';
import '../database/database.dart';
import 'image_service.dart';
import 'log_service.dart';
import 'session_service.dart';

enum SyncStatus { idle, syncing, error }

/// 同步失败原因（Service 层不持有 BuildContext，由 UI 层映射 l10n 文案）
enum SyncError {
  /// 需要会员订阅
  premiumRequired,

  /// 网络层错误（无法连接、超时）
  network,

  /// 服务端返回了已本地化的错误信息（见 [SyncService.lastErrorMessage]）
  server,

  /// 其它未知错误
  unknown,
}

/// 云同步引擎
///
/// 离线优先：本地 SQLite 为源真相。登录且开启同步时，推送本地脏数据、拉取远端增量。
/// 冲突采用 last-write-wins（按 updatedAt 毫秒）。图片上传随穿搭推送；拉取只落
/// 图片元数据（serverImageId），字节由 OutfitImage 组件首次展示时懒加载下载。
class SyncService extends ChangeNotifier {
  SyncService._();
  static final SyncService instance = SyncService._();

  static const String _kLastPulledMs = 'sync_last_pulled_ms';
  static const String _kLastSyncedMs = 'sync_last_synced_ms';

  final AppDatabase _db = AppDatabase();
  final OutfitApi _outfitApi = OutfitApi();
  final TagApi _tagApi = TagApi();
  final MediaApi _mediaApi = MediaApi();
  final GfsUploader _uploader = GfsUploader.instance;
  final ImageService _images = ImageService.instance;

  SyncStatus _status = SyncStatus.idle;
  SyncError? _lastError;
  String? _lastErrorMessage;
  int _lastSyncedMs = 0;
  bool _running = false;

  SyncStatus get status => _status;
  SyncError? get lastError => _lastError;

  /// [SyncError.server] 时服务端返回的（已本地化的）错误信息
  String? get lastErrorMessage => _lastErrorMessage;
  int get lastSyncedMs => _lastSyncedMs;
  bool get isSyncing => _status == SyncStatus.syncing;

  Future<void> loadMeta() async {
    final prefs = await SharedPreferences.getInstance();
    _lastSyncedMs = prefs.getInt(_kLastSyncedMs) ?? 0;
    notifyListeners();
  }

  /// 后台触发同步，吞掉异常（用于登录后/恢复前台/保存后等机会性同步）
  void syncInBackground() {
    syncNow().catchError((_) {});
  }

  /// 执行一次完整同步。未登录/未开启/正在同步则直接返回。
  Future<void> syncNow() async {
    final session = SessionService.instance;
    if (!session.isLoggedIn || !session.syncEnabled) return;
    if (_running) return;
    _running = true;
    _setStatus(SyncStatus.syncing, error: null);
    LogService.instance.info('Sync', 'sync start');

    try {
      await _pushTags();
      await _pushOutfits();
      await _pullTags();
      await _pullOutfits();

      final prefs = await SharedPreferences.getInstance();
      _lastSyncedMs = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt(_kLastSyncedMs, _lastSyncedMs);
      _setStatus(SyncStatus.idle, error: null);
      LogService.instance.info('Sync', 'sync done');
    } on PremiumRequiredException {
      LogService.instance.warn('Sync', 'sync failed: premium required');
      _setStatus(SyncStatus.error, error: SyncError.premiumRequired);
    } on NetworkException {
      LogService.instance.warn('Sync', 'sync failed: network');
      _setStatus(SyncStatus.error, error: SyncError.network);
    } on ApiException catch (e) {
      LogService.instance.error('Sync', 'sync failed: ${e.code}');
      _setStatus(
        SyncStatus.error,
        error: e.message.isNotEmpty ? SyncError.server : SyncError.unknown,
        message: e.message,
      );
    } catch (e, stack) {
      debugPrint('SyncService error: $e');
      LogService.instance.error('Sync', 'sync failed', e, stack);
      _setStatus(SyncStatus.error, error: SyncError.unknown);
    } finally {
      _running = false;
    }
  }

  void _setStatus(SyncStatus s, {required SyncError? error, String? message}) {
    _status = s;
    _lastError = error;
    _lastErrorMessage = (message != null && message.isNotEmpty) ? message : null;
    notifyListeners();
  }

  // --- Push -----------------------------------------------------------------

  Future<void> _pushTags() async {
    final dirty = await _db.tagDao.getDirtyTags();
    if (dirty.isEmpty) return;

    // 预取远端标签做按名去重，避免重复创建 / 409
    final remote = await _tagApi.list();
    final byName = {for (final t in remote) t.name: t.id};

    for (final tag in dirty) {
      final color = tag.color ?? '#E8F5E9';
      try {
        if (tag.serverId == null) {
          final existing = byName[tag.name];
          if (existing != null) {
            // 认领远端同名标签：base 传 0 不校验，直接覆盖颜色
            final newVer = await _tagApi.update(existing, tag.name, color, ver: 0);
            await _db.tagDao.markTagSynced(tag.id, serverId: existing, ver: newVer);
          } else {
            final id = await _tagApi.create(tag.name, color);
            await _db.tagDao.markTagSynced(tag.id, serverId: id, ver: 1);
          }
        } else {
          final newVer =
              await _tagApi.update(tag.serverId!, tag.name, color, ver: tag.ver);
          await _db.tagDao.markTagSynced(tag.id, ver: newVer);
        }
      } on ConflictException catch (e) {
        if (e.code == 'version_conflict') {
          // 远端已变更：保持 dirty 跳过，留待标签编辑入口读校验时弹框裁决
          LogService.instance.warn('Sync', 'tag ${tag.id} push ver conflict, skip');
          continue;
        }
        // 并发重名：拉一次最新映射回填
        final latest = await _tagApi.list();
        final remoteTag = {for (final t in latest) t.name: t}[tag.name];
        if (remoteTag != null) {
          await _db.tagDao
              .markTagSynced(tag.id, serverId: remoteTag.id, ver: remoteTag.ver);
        }
      }
    }
  }

  Future<void> _pushOutfits() async {
    final dirty = await _db.outfitDao.getDirtyOutfits();
    for (final o in dirty) {
      if (o.isDeleted == 1) {
        if (o.serverId != null) {
          try {
            await _outfitApi.delete(o.serverId!, ver: o.ver);
          } on ConflictException catch (e) {
            if (e.code == 'version_conflict') {
              // 远端已变更：保持 dirty 跳过，留待详情页入口读校验时弹框裁决
              LogService.instance
                  .warn('Sync', 'outfit ${o.id} delete ver conflict, skip');
              continue;
            }
            rethrow;
          } on ApiException catch (e) {
            if (e.status != 404) rethrow;
          }
        }
        await _db.outfitDao.markOutfitSynced(o.id);
        continue;
      }

      final imageIds = await _ensureImagesUploaded(o.id, o.date);
      final tagRecords = await _db.tagDao.getTagsByOutfitId(o.id);
      final tags = tagRecords
          .map((t) => {'name': t.name, 'color': t.color ?? '#E8F5E9'})
          .toList();

      final OutfitWriteResult res;
      if (o.serverId == null) {
        res = await _outfitApi.create(
          date: o.date,
          description: o.description,
          tags: tags,
          imageIds: imageIds,
          createdAt: o.createdAt,
          updatedAt: o.updatedAt,
        );
        await _db.outfitDao.markOutfitSynced(o.id, serverId: res.id, ver: res.ver);
      } else {
        try {
          res = await _outfitApi.update(
            o.serverId!,
            date: o.date,
            description: o.description,
            tags: tags,
            imageIds: imageIds,
            createdAt: o.createdAt,
            updatedAt: o.updatedAt,
            ver: o.ver,
          );
        } on ConflictException catch (e) {
          if (e.code == 'version_conflict') {
            // 远端已变更：保持 dirty 跳过，留待详情页入口读校验时弹框裁决
            LogService.instance
                .warn('Sync', 'outfit ${o.id} push ver conflict, skip');
            continue;
          }
          rethrow;
        }
        await _db.outfitDao.markOutfitSynced(o.id, ver: res.ver);
      }

      // 回填标签 serverId（服务端按 name 去重后返回 name→id）
      for (final entry in res.tagIds.entries) {
        final local = await _db.tagDao.getTagByName(entry.key);
        if (local != null && local.serverId == null) {
          await _db.tagDao.setTagServerId(local.id, entry.value);
        }
      }
    }
  }

  /// 确保某 outfit 的所有图片已上传到 GFS，返回按显示顺序的 image_ids。
  Future<List<int>> _ensureImagesUploaded(int localOutfitId, int dateMs) async {
    final images = await _db.imageDao.getImagesByOutfitId(localOutfitId);
    final ids = <int>[];
    for (final img in images) {
      if (img.serverImageId != null) {
        ids.add(img.serverImageId!);
        continue;
      }
      final path = img.imagePath;
      if (path == null) continue; // 云端图未下载且无 serverImageId（异常态），跳过
      final file = await _images.getImageFile(path);
      if (file == null) continue; // 本地文件缺失，跳过
      final policy = await _mediaApi.uploadToken(usage: 'outfit');
      final serverImageId = await _uploader.upload(file, policy);
      await _db.imageDao.setServerImageId(img.id, serverImageId);
      ids.add(serverImageId);
    }
    return ids;
  }

  // --- Pull -----------------------------------------------------------------

  Future<void> _pullTags() async {
    final remote = await _tagApi.list();
    for (final t in remote) {
      await _db.tagDao
          .upsertRemoteTag(serverId: t.id, name: t.name, color: t.color, ver: t.ver);
    }
  }

  Future<void> _pullOutfits() async {
    final prefs = await SharedPreferences.getInstance();
    final since = prefs.getInt(_kLastPulledMs) ?? 0;
    int maxUpdated = since;
    String? cursor;

    while (true) {
      final page = await _outfitApi.list(since: since, cursor: cursor);
      for (final ro in page.items) {
        if (ro.updatedAt > maxUpdated) maxUpdated = ro.updatedAt;
        await applyRemoteOutfit(ro);
      }
      if (!page.hasMore || page.nextCursor.isEmpty) break;
      cursor = page.nextCursor;
    }

    await prefs.setInt(_kLastPulledMs, maxUpdated);
  }

  /// 把一条远端 outfit 应用到本地库。常规拉取时本地 dirty 优先、按 updatedAt
  /// 跳过旧数据；[force] = true 时无条件覆盖（详情页冲突裁决"用云端"/接受删除）。
  Future<void> applyRemoteOutfit(RemoteOutfit ro, {bool force = false}) async {
    final local = await _db.outfitDao.getOutfitByServerId(ro.id);

    if (local == null) {
      if (ro.isDeleted) return; // 远端已删且本地没有，忽略
      final newId = await _db.outfitDao.insertRemoteOutfit(
        serverId: ro.id,
        dateMs: ro.date,
        description: ro.description,
        createdAtMs: ro.createdAt,
        updatedAtMs: ro.updatedAt,
        isDeleted: false,
        ver: ro.ver,
      );
      await _applyRemoteTags(newId, ro.tags);
      await _applyRemoteImages(newId, ro.imageIds);
      return;
    }

    if (!force) {
      // 本地有未推送改动 → 本地优先，等下一轮推送解决
      if (local.dirty == 1) return;
      // 远端不更新 → 跳过
      if (ro.updatedAt <= local.updatedAt) return;
    }

    await _db.outfitDao.updateOutfitFromRemote(
      local.id,
      dateMs: ro.date,
      description: ro.description,
      updatedAtMs: ro.updatedAt,
      isDeleted: ro.isDeleted,
      ver: ro.ver,
    );
    await _applyRemoteTags(local.id, ro.tags);

    // 图片集合变化时重建元数据行（字节由组件懒加载）
    final localImages = await _db.imageDao.getImagesByOutfitId(local.id);
    final localServerIds = localImages.map((e) => e.serverImageId).toList();
    if (!_sameIds(localServerIds, ro.imageIds)) {
      final paths =
          localImages.map((e) => e.imagePath).whereType<String>().toList();
      await _images.deleteOutfitImages(paths);
      await _db.imageDao.deleteImagesByOutfitId(local.id);
      await _applyRemoteImages(local.id, ro.imageIds);
    }
  }

  Future<void> _applyRemoteTags(int localOutfitId, List<RemoteTag> tags) async {
    final localTagIds = <int>[];
    for (final t in tags) {
      await _db.tagDao.upsertRemoteTag(serverId: t.id, name: t.name, color: t.color);
      final local = await _db.tagDao.getTagByName(t.name);
      if (local != null) localTagIds.add(local.id);
    }
    await _db.tagDao.setOutfitTags(localOutfitId, localTagIds);
  }

  /// 写入远端图片元数据行（imagePath 为 null）。
  /// 图片字节不在同步期下载，由 OutfitImage 组件首次展示时懒加载。
  Future<void> _applyRemoteImages(int localOutfitId, List<int> imageIds) async {
    for (int i = 0; i < imageIds.length; i++) {
      await _db.imageDao.insertRemoteImage(
        outfitId: localOutfitId,
        displayOrder: i,
        serverImageId: imageIds[i],
      );
    }
  }

  bool _sameIds(List<int?> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
