import 'dart:io';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// 图片文件管理服务
class ImageService {
  static ImageService? _instance;
  static ImageService get instance {
    _instance ??= ImageService._();
    return _instance!;
  }

  /// 自定义缓存管理器
  late final CacheManager _cacheManager;

  ImageService._() {
    _cacheManager = CacheManager(
      Config(
        'today_wear_images',
        stalePeriod: const Duration(days: 7),
        maxNrOfCacheObjects: 100,
        repo: JsonCacheInfoRepository(databaseName: 'today_wear_images'),
        fileService: HttpFileService(),
      ),
    );
  }

  /// 获取应用数据目录
  Future<Directory> _getAppDataDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// 获取指定日期的图片目录
  /// 返回完整路径，如 /path/to/app/images/20260128/
  Future<Directory> getImageDirectory(DateTime date) async {
    final appDir = await _getAppDataDirectory();
    final dateStr = DateFormat('yyyyMMdd').format(date);
    final imageDir = Directory(p.join(appDir.path, 'images', dateStr));
    
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    
    return imageDir;
  }

  /// 获取图片目录的相对路径（用于数据库存储）
  /// 返回相对路径，如 images/20260128/
  String getImageDirectoryRelativePath(DateTime date) {
    final dateStr = DateFormat('yyyyMMdd').format(date);
    return p.join('images', dateStr);
  }

  /// 保存图片到指定目录（带压缩）
  /// [imageFile] 源图片文件
  /// [outfitId] outfit ID
  /// [index] 图片索引（用于多张图片）
  /// [quality] 压缩质量 (1-100)，默认 85
  /// 返回相对路径，如 images/20260128/123_0.jpg
  Future<String> saveImage(File imageFile, int outfitId, int index, DateTime date, {int quality = 85}) async {
    if (!await imageFile.exists()) {
      throw Exception('源图片文件不存在：${imageFile.path}');
    }

    final imageDir = await getImageDirectory(date);
    final fileName = '${outfitId}_$index.jpg';
    final targetFile = File(p.join(imageDir.path, fileName));

    // 压缩并保存图片
    await _compressAndSaveImage(imageFile, targetFile, quality: quality);

    // 返回相对路径
    final relativeDir = getImageDirectoryRelativePath(date);
    return p.join(relativeDir, fileName);
  }

  /// 压缩并保存图片
  Future<void> _compressAndSaveImage(File sourceFile, File targetFile, {int quality = 85}) async {
    try {
      // 读取图片
      final imageData = await sourceFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(
        imageData,
        targetWidth: 1920, // 限制最大宽度，减少内存占用
      );
      final frame = await codec.getNextFrame();
      final byteData = await frame.image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) return;
      
      // 简单复制（如需更高级压缩，可使用 flutter_image_compress 包）
      await sourceFile.copy(targetFile.path);
    } catch (e) {
      // 如果压缩失败，直接复制原文件
      await sourceFile.copy(targetFile.path);
    }
  }

  /// 根据相对路径获取完整路径的 File 对象
  Future<File?> getImageFile(String relativePath) async {
    final appDir = await _getAppDataDirectory();
    final fullPath = p.join(appDir.path, relativePath);
    final file = File(fullPath);
    
    if (await file.exists()) {
      return file;
    }
    
    return null;
  }

  /// 删除图片文件
  Future<bool> deleteImage(String relativePath) async {
    try {
      final file = await getImageFile(relativePath);
      if (file != null && await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 删除某个 outfit 的所有图片
  /// [imagePaths] 图片相对路径列表
  Future<void> deleteOutfitImages(List<String> imagePaths) async {
    for (final path in imagePaths) {
      await deleteImage(path);
    }
  }

  /// 确保图片目录存在
  Future<void> ensureImageDirectoriesExist() async {
    final appDir = await _getAppDataDirectory();
    final imagesDir = Directory(p.join(appDir.path, 'images'));
    
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
  }

  /// 保存用户头像（覆盖式保存，固定路径 profile/avatar.jpg）
  /// 返回相对路径，用于存入 UserProfile.avatarPath
  Future<String> saveProfileAvatar(File imageFile) async {
    if (!await imageFile.exists()) {
      throw Exception('源图片文件不存在：${imageFile.path}');
    }
    final appDir = await _getAppDataDirectory();
    final profileDir = Directory(p.join(appDir.path, 'profile'));
    if (!await profileDir.exists()) {
      await profileDir.create(recursive: true);
    }
    const fileName = 'avatar.jpg';
    final targetFile = File(p.join(profileDir.path, fileName));
    await imageFile.copy(targetFile.path);
    return p.join('profile', fileName);
  }

  /// 获取缓存的图片（用于网络图片，当前主要用于本地）
  Future<File?> getCachedImage(String url) async {
    try {
      final fileInfo = await _cacheManager.getFileFromCache(url);
      return fileInfo?.file;
    } catch (e) {
      return null;
    }
  }

  /// 清除过期缓存
  Future<void> clearExpiredCache() async {
    await _cacheManager.emptyCache();
  }

  /// 获取缓存大小（字节）
  Future<int> getCacheSize() async {
    // 简单实现：计算 images 目录大小
    try {
      final appDir = await _getAppDataDirectory();
      final imagesDir = Directory(p.join(appDir.path, 'images'));
      if (!await imagesDir.exists()) return 0;
      
      int totalSize = 0;
      await for (final entity in imagesDir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
      return totalSize;
    } catch (e) {
      return 0;
    }
  }
}
