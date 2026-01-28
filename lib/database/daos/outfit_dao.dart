import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'outfit_dao.g.dart';

/// Outfit 数据访问对象
@DriftAccessor(tables: [Outfits, OutfitTags])
class OutfitDao extends DatabaseAccessor<AppDatabase> with _$OutfitDaoMixin {
  OutfitDao(AppDatabase db) : super(db);

  /// 获取所有未删除的 outfits（按日期倒序）
  Future<List<OutfitData>> getAllOutfits({int? limit, int? offset}) async {
    final query = select(outfits)
      ..where((tbl) => tbl.isDeleted.equals(0))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]);
    
    if (limit != null) {
      query.limit(limit, offset: offset ?? 0);
    }
    
    return await query.get();
  }

  /// 根据 ID 获取 outfit
  Future<OutfitData?> getOutfitById(int id) async {
    return await (select(outfits)
          ..where((tbl) => tbl.id.equals(id) & tbl.isDeleted.equals(0)))
        .getSingleOrNull();
  }

  /// 根据日期范围查询
  Future<List<OutfitData>> getOutfitsByDateRange(DateTime start, DateTime end) async {
    final startTimestamp = start.millisecondsSinceEpoch;
    final endTimestamp = end.millisecondsSinceEpoch;
    
    return await (select(outfits)
          ..where((tbl) =>
              tbl.date.isBiggerOrEqualValue(startTimestamp) &
              tbl.date.isSmallerOrEqualValue(endTimestamp) &
              tbl.isDeleted.equals(0))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .get();
  }

  /// 全文搜索（description LIKE）
  Future<List<OutfitData>> searchOutfits(String keyword) async {
    final searchPattern = '%$keyword%';
    return await (select(outfits)
          ..where((tbl) =>
              tbl.description.like(searchPattern) & tbl.isDeleted.equals(0))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .get();
  }

  /// 插入新 outfit
  Future<int> insertOutfit(OutfitsCompanion outfit) async {
    return await into(outfits).insert(outfit);
  }

  /// 更新 outfit
  Future<bool> updateOutfit(OutfitData outfit) async {
    final companion = OutfitsCompanion(
      id: Value(outfit.id),
      date: Value(outfit.date),
      description: Value(outfit.description),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    );
    
    return await update(outfits).replace(companion);
  }

  /// 软删除 outfit
  Future<bool> deleteOutfit(int id) async {
    final result = await (update(outfits)..where((tbl) => tbl.id.equals(id)))
        .write(OutfitsCompanion(
      isDeleted: const Value(1),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ));
    return result > 0;
  }

  /// 永久删除 outfit（物理删除）
  Future<bool> permanentlyDeleteOutfit(int id) async {
    // 先删除关联的 tags
    await (delete(outfitTags)..where((tbl) => tbl.outfitId.equals(id))).go();
    
    // 删除 outfit
    final result = await (delete(outfits)..where((tbl) => tbl.id.equals(id))).go();
    return result > 0;
  }

  /// 获取统计信息（某年某月的记录数）
  Future<int> getOutfitCountByMonth(int year, int month) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);
    final startTimestamp = startDate.millisecondsSinceEpoch;
    final endTimestamp = endDate.millisecondsSinceEpoch;
    
    final count = await (selectOnly(outfits)
          ..addColumns([outfits.id.count()])
          ..where(
              outfits.date.isBiggerOrEqualValue(startTimestamp) &
              outfits.date.isSmallerOrEqualValue(endTimestamp) &
              outfits.isDeleted.equals(0)))
        .getSingle();
    
    return count.read(outfits.id.count()) ?? 0;
  }
}
