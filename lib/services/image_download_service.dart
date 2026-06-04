import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/media_api.dart';
import '../database/database.dart';
import '../models/outfit.dart';
import 'image_service.dart';

/// 云端图片懒加载下载服务
///
/// 按 serverImageId 去重下载：同 id 的并发请求合并到同一个 Future；
/// 流程：查库（已下载直接返回）→ 换签名 URL → 下载字节 → 落盘到 images/ 目录
/// → 回填 OutfitImages.imagePath。回填后该图片与本地拍摄的图完全同构，
/// 后续访问不再重复下载。任一步失败返回 null（不抛异常）。
class ImageDownloadService {
  ImageDownloadService._()
      : _db = AppDatabase(),
        _mediaApi = MediaApi(),
        _images = ImageService.instance,
        _http = http.Client();

  /// 测试用构造（注入依赖）
  @visibleForTesting
  ImageDownloadService.forTesting({
    required AppDatabase db,
    required MediaApi mediaApi,
    required ImageService images,
    required http.Client httpClient,
  })  : _db = db,
        _mediaApi = mediaApi,
        _images = images,
        _http = httpClient;

  static final ImageDownloadService instance = ImageDownloadService._();

  final AppDatabase _db;
  final MediaApi _mediaApi;
  final ImageService _images;
  final http.Client _http;

  /// 进行中的下载（serverImageId → Future），用于并发去重
  final Map<int, Future<File?>> _inflight = {};

  /// 确保 [serverImageId] 对应的图片已下载到本地，返回本地文件。
  /// 失败（断网、未登录、云端已删等）返回 null。
  Future<File?> ensureDownloaded(int serverImageId) {
    final pending = _inflight[serverImageId];
    if (pending != null) return pending;

    // 注意：回调必须返回 void——若返回 Map.remove 删下的 Future（即本 future），
    // whenComplete 会等待它自己，造成死锁。
    final future = _ensureDownloaded(serverImageId).whenComplete(() {
      _inflight.remove(serverImageId);
    });
    _inflight[serverImageId] = future;
    return future;
  }

  /// 确保一组照片的图片全部已下载，返回各自的本地文件（失败项为 null）。
  /// 进入详情/编辑页时调用：PageView 等懒构建的 UI 只会触发可见图的下载，
  /// 这里把整条穿搭的未下载图一并拉下来。
  Future<List<File?>> ensureAllDownloaded(List<OutfitPhoto> photos) {
    return Future.wait(photos.map((p) async {
      final path = p.localPath;
      if (path != null) {
        final file = await _images.getImageFile(path);
        if (file != null) return file;
      }
      final id = p.serverImageId;
      if (id == null) return null;
      return ensureDownloaded(id);
    }));
  }

  Future<File?> _ensureDownloaded(int serverImageId) async {
    try {
      final record = await _db.imageDao.getImageByServerId(serverImageId);
      if (record == null) return null;

      // 已有本地路径且文件存在 → 不重复下载
      final existingPath = record.imagePath;
      if (existingPath != null) {
        final file = await _images.getImageFile(existingPath);
        if (file != null) return file;
      }

      // 换取签名 URL（1h 有效，每次下载前实时换取）
      final urls = await _mediaApi.imageUrls([serverImageId]);
      final url = urls[serverImageId];
      if (url == null || url.isEmpty) return null;

      // 下载字节
      final res = await _http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 30));
      if (res.statusCode < 200 || res.statusCode >= 300) return null;

      // 落盘 + 回填路径（写盘失败不回填，下次访问仍会重下）
      final outfit = await _db.outfitDao.getOutfitByIdRaw(record.outfitId);
      final date = outfit != null
          ? DateTime.fromMillisecondsSinceEpoch(outfit.date)
          : DateTime.now();
      final path = await _images.saveImageBytes(
        res.bodyBytes,
        record.outfitId,
        record.displayOrder,
        date,
      );
      await _db.imageDao.setImagePathByServerId(serverImageId, path);
      return await _images.getImageFile(path);
    } catch (e) {
      debugPrint('ImageDownloadService download failed ($serverImageId): $e');
      return null;
    }
  }
}
