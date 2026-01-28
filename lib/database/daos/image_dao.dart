import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'image_dao.g.dart';

/// Image 数据访问对象
@DriftAccessor(tables: [OutfitImages])
class ImageDao extends DatabaseAccessor<AppDatabase> with _$ImageDaoMixin {
  ImageDao(AppDatabase db) : super(db);

  /// 获取 outfit 的所有图片（按显示顺序）
  Future<List<OutfitImageData>> getImagesByOutfitId(int outfitId) async {
    return await (select(outfitImages)
          ..where((tbl) => tbl.outfitId.equals(outfitId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.displayOrder)]))
        .get();
  }

  /// 插入图片
  Future<int> insertImage(OutfitImagesCompanion image) async {
    return await into(outfitImages).insert(image);
  }

  /// 批量插入图片
  Future<void> insertImages(List<OutfitImagesCompanion> images) async {
    await batch((batch) {
      batch.insertAll(outfitImages, images);
    });
  }

  /// 删除图片
  Future<bool> deleteImage(int imageId) async {
    final result = await (delete(outfitImages)..where((tbl) => tbl.id.equals(imageId)))
        .go();
    return result > 0;
  }

  /// 删除 outfit 的所有图片
  Future<void> deleteImagesByOutfitId(int outfitId) async {
    await (delete(outfitImages)..where((tbl) => tbl.outfitId.equals(outfitId)))
        .go();
  }

  /// 更新图片显示顺序
  Future<bool> updateImageOrder(int imageId, int displayOrder) async {
    final result = await (update(outfitImages)..where((tbl) => tbl.id.equals(imageId)))
        .write(OutfitImagesCompanion(displayOrder: Value(displayOrder)));
    return result > 0;
  }
}
