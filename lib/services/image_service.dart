import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// 图片文件管理服务
class ImageService {
  static ImageService? _instance;
  static ImageService get instance {
    _instance ??= ImageService._();
    return _instance!;
  }

  ImageService._();

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

  /// 保存图片到指定目录
  /// [imageFile] 源图片文件
  /// [outfitId] outfit ID
  /// [index] 图片索引（用于多张图片）
  /// 返回相对路径，如 images/20260128/123_0.jpg
  Future<String> saveImage(File imageFile, int outfitId, int index, DateTime date) async {
    if (!await imageFile.exists()) {
      throw Exception('源图片文件不存在: ${imageFile.path}');
    }

    final imageDir = await getImageDirectory(date);
    final fileName = '${outfitId}_$index.jpg';
    final targetFile = File(p.join(imageDir.path, fileName));

    // 复制文件
    await imageFile.copy(targetFile.path);

    // 返回相对路径
    final relativeDir = getImageDirectoryRelativePath(date);
    return p.join(relativeDir, fileName);
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
      throw Exception('源图片文件不存在: ${imageFile.path}');
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
}
