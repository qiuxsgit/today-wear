import 'package:drift/drift.dart';

/// Outfits 表
@DataClassName('OutfitData')
class Outfits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get date => integer()(); // Unix 时间戳
  TextColumn get description => text()();
  IntColumn get createdAt => integer()(); // Unix 时间戳
  IntColumn get updatedAt => integer()(); // Unix 时间戳
  IntColumn get isDeleted => integer().withDefault(const Constant(0))(); // 0/1
}

/// Tags 表
@DataClassName('TagData')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  /// 标签颜色，存 hex 如 #E8F5E9，可为空（旧数据兼容），读取时用默认色
  TextColumn get color => text().nullable().withDefault(const Constant('#E8F5E9'))();
}

/// OutfitTags 关联表（多对多）
class OutfitTags extends Table {
  IntColumn get outfitId => integer()();
  IntColumn get tagId => integer()();
  
  @override
  Set<Column> get primaryKey => {outfitId, tagId};
}

/// OutfitImages 表（支持多张图片）
@DataClassName('OutfitImageData')
class OutfitImages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get outfitId => integer()();
  TextColumn get imagePath => text()(); // 相对路径，如 images/20260128/123_0.jpg
  IntColumn get displayOrder => integer()(); // 显示顺序
}
