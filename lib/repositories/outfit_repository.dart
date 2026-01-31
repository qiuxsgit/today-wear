import 'dart:io';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../models/outfit.dart' as models;
import '../services/image_service.dart';
import '../theme/tag_colors.dart';

/// Outfit 数据仓库
/// 
/// 封装所有数据库操作，提供高级查询方法
class OutfitRepository {
  final AppDatabase _db;
  final ImageService _imageService;

  OutfitRepository(this._db) : _imageService = ImageService.instance;

  /// 获取所有 outfits（分页）
  Future<List<models.Outfit>> getAllOutfits({int? limit, int? offset}) async {
    final outfitRecords = await _db.outfitDao.getAllOutfits(
      limit: limit,
      offset: offset,
    );

    return await _loadOutfitsWithRelations(outfitRecords);
  }

  /// 根据 ID 获取 outfit
  Future<models.Outfit?> getOutfitById(int id) async {
    final outfitRecord = await _db.outfitDao.getOutfitById(id);
    if (outfitRecord == null) {
      return null;
    }

    return await _loadOutfitWithRelations(outfitRecord);
  }

  /// 根据日期范围查询
  Future<List<models.Outfit>> getOutfitsByDateRange(DateTime start, DateTime end) async {
    final outfitRecords = await _db.outfitDao.getOutfitsByDateRange(start, end);
    return await _loadOutfitsWithRelations(outfitRecords);
  }

  /// 根据标签筛选
  Future<List<models.Outfit>> getOutfitsByTag(String tagName) async {
    // 先找到 tag
    final tag = await _db.tagDao.getTagByName(tagName);
    if (tag == null) {
      return [];
    }

    // 找到所有使用此 tag 的 outfit IDs
    final outfitTags = await (_db.select(_db.outfitTags)
          ..where((tbl) => tbl.tagId.equals(tag.id)))
        .get();

    if (outfitTags.isEmpty) {
      return [];
    }

    final outfitIds = outfitTags.map((ot) => ot.outfitId).toList();
    
    // 查询这些 outfits
    final outfitRecords = await (_db.select(_db.outfits)
          ..where((tbl) =>
              tbl.id.isIn(outfitIds) & tbl.isDeleted.equals(0))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .get();

    return await _loadOutfitsWithRelations(outfitRecords);
  }

  /// 全文搜索
  Future<List<models.Outfit>> searchOutfits(String keyword) async {
    final outfitRecords = await _db.outfitDao.searchOutfits(keyword);
    return await _loadOutfitsWithRelations(outfitRecords);
  }

  /// 获取统计信息
  Future<int> getOutfitCountByMonth(int year, int month) async {
    return await _db.outfitDao.getOutfitCountByMonth(year, month);
  }

  /// 保存 outfit（新建或更新）
  /// [outfit] Outfit 模型
  /// [imageFiles] 图片文件列表（可选，新建时使用）
  Future<int> saveOutfit(models.Outfit outfit, {List<File>? imageFiles}) async {
    final now = DateTime.now();
    final nowTimestamp = now.millisecondsSinceEpoch;

    if (outfit.id == 0) {
      // 新建
      final companion = OutfitsCompanion.insert(
        date: outfit.date.millisecondsSinceEpoch,
        description: outfit.description,
        createdAt: nowTimestamp,
        updatedAt: nowTimestamp,
      );

      final outfitId = await _db.outfitDao.insertOutfit(companion);

      // 保存 tags
      if (outfit.tags.isNotEmpty) {
        await _saveTagsForOutfit(outfitId, outfit.tags);
      }

      // 保存图片
      if (imageFiles != null && imageFiles.isNotEmpty) {
        await _saveImagesForOutfit(outfitId, imageFiles, outfit.date);
      }

      return outfitId;
    } else {
      // 更新
      final companion = OutfitsCompanion(
        id: Value(outfit.id),
        date: Value(outfit.date.millisecondsSinceEpoch),
        description: Value(outfit.description),
        updatedAt: Value(nowTimestamp),
      );

      // 获取现有记录以保留 createdAt
      final existing = await _db.outfitDao.getOutfitById(outfit.id);
      if (existing == null) {
        throw Exception('Outfit not found: ${outfit.id}');
      }
      
      final outfitData = OutfitData(
        id: outfit.id,
        date: outfit.date.millisecondsSinceEpoch,
        description: outfit.description,
        createdAt: existing.createdAt, // 保留原有创建时间
        updatedAt: nowTimestamp,
        isDeleted: existing.isDeleted,
      );
      await _db.outfitDao.updateOutfit(outfitData);

      // 更新 tags
      await _saveTagsForOutfit(outfit.id, outfit.tags);

      // 如果提供了新图片，替换旧图片
      if (imageFiles != null) {
        // 删除旧图片
        final oldImages = await _db.imageDao.getImagesByOutfitId(outfit.id);
        final oldPaths = oldImages.map((img) => img.imagePath).toList();
        await _imageService.deleteOutfitImages(oldPaths);
        await _db.imageDao.deleteImagesByOutfitId(outfit.id);

        // 保存新图片
        if (imageFiles.isNotEmpty) {
          await _saveImagesForOutfit(outfit.id, imageFiles, outfit.date);
        }
      }

      return outfit.id;
    }
  }

  /// 删除 outfit（软删除）
  Future<bool> deleteOutfit(int id) async {
    return await _db.outfitDao.deleteOutfit(id);
  }

  /// 永久删除 outfit（物理删除，包括图片文件）
  Future<bool> permanentlyDeleteOutfit(int id) async {
    // 删除图片文件
    final images = await _db.imageDao.getImagesByOutfitId(id);
    final imagePaths = images.map((img) => img.imagePath).toList();
    await _imageService.deleteOutfitImages(imagePaths);

    // 删除数据库记录
    return await _db.outfitDao.permanentlyDeleteOutfit(id);
  }

  /// 保存 tags 到 outfit
  Future<void> _saveTagsForOutfit(int outfitId, List<String> tagNames) async {
    final tagIds = <int>[];
    
    for (final tagName in tagNames) {
      final tag = await _db.tagDao.getOrCreateTag(tagName);
      tagIds.add(tag.id);
    }

    await _db.tagDao.setOutfitTags(outfitId, tagIds);
  }

  /// 保存图片到 outfit
  Future<void> _saveImagesForOutfit(
    int outfitId,
    List<File> imageFiles,
    DateTime date,
  ) async {
    final imageCompanions = <OutfitImagesCompanion>[];

    for (int i = 0; i < imageFiles.length; i++) {
      final relativePath = await _imageService.saveImage(
        imageFiles[i],
        outfitId,
        i,
        date,
      );

      imageCompanions.add(
        OutfitImagesCompanion.insert(
          outfitId: outfitId,
          imagePath: relativePath,
          displayOrder: i,
        ),
      );
    }

    await _db.imageDao.insertImages(imageCompanions);
  }

  /// 加载 outfit 及其关联数据（tags 和 images）
  Future<models.Outfit> _loadOutfitWithRelations(OutfitData outfitRecord) async {
    final outfitId = outfitRecord.id;
    
    // 加载 tags（含颜色）
    final tagRecords = await _db.tagDao.getTagsByOutfitId(outfitId);
    final tags = tagRecords.map((t) => t.name).toList();
    final tagColors = tagRecords
        .map((t) => t.color ?? TagColors.defaultColorHex)
        .toList();

    // 加载图片
    final imageRecords = await _db.imageDao.getImagesByOutfitId(outfitId);
    final photoPaths = imageRecords.map((img) => img.imagePath).toList();

    return models.Outfit(
      id: outfitId,
      date: DateTime.fromMillisecondsSinceEpoch(outfitRecord.date),
      description: outfitRecord.description,
      tags: tags,
      tagColors: tagColors,
      photoPaths: photoPaths,
    );
  }

  /// 批量加载 outfits 及其关联数据
  Future<List<models.Outfit>> _loadOutfitsWithRelations(List<OutfitData> outfitRecords) async {
    final outfits = <models.Outfit>[];

    for (final record in outfitRecords) {
      final outfit = await _loadOutfitWithRelations(record);
      outfits.add(outfit);
    }

    return outfits;
  }
}
