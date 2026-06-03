import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_exception.dart';
import '../api/media_api.dart';
import '../api/outfit_api.dart';
import '../api/tag_api.dart';
import '../api/gfs_uploader.dart';
import '../database/database.dart';
import 'image_service.dart';
import 'session_service.dart';

enum SyncStatus { idle, syncing, error }

/// 云同步引擎
///
/// 离线优先：本地 SQLite 为源真相。登录且开启同步时，推送本地脏数据、拉取远端增量。
/// 冲突采用 last-write-wins（按 updatedAt 毫秒）。图片随穿搭一起上云/下载到本地。
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
  final http.Client _http = http.Client();

  SyncStatus _status = SyncStatus.idle;
  String? _lastError;
  int _lastSyncedMs = 0;
  bool _running = false;

  SyncStatus get status => _status;
  String? get lastError => _lastError;
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

    try {
      await _pushTags();
      await _pushOutfits();
      await _pullTags();
      await _pullOutfits();

      final prefs = await SharedPreferences.getInstance();
      _lastSyncedMs = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt(_kLastSyncedMs, _lastSyncedMs);
      _setStatus(SyncStatus.idle, error: null);
    } on PremiumRequiredException {
      _setStatus(SyncStatus.error, error: '云同步需要会员订阅');
    } on ApiException catch (e) {
      _setStatus(SyncStatus.error, error: e.message);
    } catch (e) {
      debugPrint('SyncService error: $e');
      _setStatus(SyncStatus.error, error: '同步失败，请稍后重试');
    } finally {
      _running = false;
    }
  }

  void _setStatus(SyncStatus s, {required String? error}) {
    _status = s;
    _lastError = error;
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
            await _tagApi.update(existing, tag.name, color);
            await _db.tagDao.markTagSynced(tag.id, serverId: existing);
          } else {
            final id = await _tagApi.create(tag.name, color);
            await _db.tagDao.markTagSynced(tag.id, serverId: id);
          }
        } else {
          await _tagApi.update(tag.serverId!, tag.name, color);
          await _db.tagDao.markTagSynced(tag.id);
        }
      } on ConflictException {
        // 并发重名：拉一次最新映射回填
        final latest = await _tagApi.list();
        final id = {for (final t in latest) t.name: t.id}[tag.name];
        if (id != null) await _db.tagDao.markTagSynced(tag.id, serverId: id);
      }
    }
  }

  Future<void> _pushOutfits() async {
    final dirty = await _db.outfitDao.getDirtyOutfits();
    for (final o in dirty) {
      if (o.isDeleted == 1) {
        if (o.serverId != null) {
          try {
            await _outfitApi.delete(o.serverId!);
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
        await _db.outfitDao.markOutfitSynced(o.id, serverId: res.id);
      } else {
        res = await _outfitApi.update(
          o.serverId!,
          date: o.date,
          description: o.description,
          tags: tags,
          imageIds: imageIds,
          createdAt: o.createdAt,
          updatedAt: o.updatedAt,
        );
        await _db.outfitDao.markOutfitSynced(o.id);
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
      final file = await _images.getImageFile(img.imagePath);
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
      await _db.tagDao.upsertRemoteTag(serverId: t.id, name: t.name, color: t.color);
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
        await _applyRemoteOutfit(ro);
      }
      if (!page.hasMore || page.nextCursor.isEmpty) break;
      cursor = page.nextCursor;
    }

    await prefs.setInt(_kLastPulledMs, maxUpdated);
  }

  Future<void> _applyRemoteOutfit(RemoteOutfit ro) async {
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
      );
      await _applyRemoteTags(newId, ro.tags);
      await _downloadImages(newId, ro.date, ro.imageIds, ro.imageUrls);
      return;
    }

    // 本地有未推送改动 → 本地优先，等下一轮推送解决
    if (local.dirty == 1) return;
    // 远端不更新 → 跳过
    if (ro.updatedAt <= local.updatedAt) return;

    await _db.outfitDao.updateOutfitFromRemote(
      local.id,
      dateMs: ro.date,
      description: ro.description,
      updatedAtMs: ro.updatedAt,
      isDeleted: ro.isDeleted,
    );
    await _applyRemoteTags(local.id, ro.tags);

    // 图片集合变化时重新下载
    final localImages = await _db.imageDao.getImagesByOutfitId(local.id);
    final localServerIds = localImages.map((e) => e.serverImageId).toList();
    if (!_sameIds(localServerIds, ro.imageIds)) {
      final paths = localImages.map((e) => e.imagePath).toList();
      await _images.deleteOutfitImages(paths);
      await _db.imageDao.deleteImagesByOutfitId(local.id);
      await _downloadImages(local.id, ro.date, ro.imageIds, ro.imageUrls);
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

  /// 下载远端图片到本地磁盘（让现有 UI 无改动地按本地文件渲染）
  Future<void> _downloadImages(
    int localOutfitId,
    int dateMs,
    List<int> imageIds,
    List<String> imageUrls,
  ) async {
    final date = DateTime.fromMillisecondsSinceEpoch(dateMs);
    for (int i = 0; i < imageIds.length; i++) {
      if (i >= imageUrls.length) break; // 无对应读 URL（GFS 未配置等）
      final url = imageUrls[i];
      if (url.isEmpty) continue;
      final bytes = await _download(url);
      if (bytes == null) continue;
      final path = await _images.saveImageBytes(bytes, localOutfitId, i, date);
      await _db.imageDao.insertRemoteImage(
        outfitId: localOutfitId,
        imagePath: path,
        displayOrder: i,
        serverImageId: imageIds[i],
      );
    }
  }

  Future<List<int>?> _download(String url) async {
    try {
      final res = await _http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));
      if (res.statusCode >= 200 && res.statusCode < 300) return res.bodyBytes;
    } catch (e) {
      debugPrint('SyncService image download failed: $e');
    }
    return null;
  }

  bool _sameIds(List<int?> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
