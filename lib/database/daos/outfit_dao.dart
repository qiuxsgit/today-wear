import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'outfit_dao.g.dart';

/// Outfit 数据访问对象
@DriftAccessor(tables: [Outfits, OutfitTags, Tags])
class OutfitDao extends DatabaseAccessor<AppDatabase> with _$OutfitDaoMixin {
  OutfitDao(super.db);

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

  /// 更新 outfit 内容（保留 createdAt / serverId / isDeleted，标记 dirty 待同步）
  Future<bool> updateOutfitContent(int id, int dateMs, String description) async {
    final result = await (update(outfits)..where((tbl) => tbl.id.equals(id)))
        .write(OutfitsCompanion(
      date: Value(dateMs),
      description: Value(description),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      dirty: const Value(1),
    ));
    return result > 0;
  }

  /// 软删除 outfit（标记 dirty 待同步）
  Future<bool> deleteOutfit(int id) async {
    final result = await (update(outfits)..where((tbl) => tbl.id.equals(id)))
        .write(OutfitsCompanion(
      isDeleted: const Value(1),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      dirty: const Value(1),
    ));
    return result > 0;
  }

  // --- 云同步辅助 ---------------------------------------------------------

  /// 获取所有待推送（dirty=1）的 outfit，含已软删的（删除也需推送）
  Future<List<OutfitData>> getDirtyOutfits() async {
    return await (select(outfits)..where((tbl) => tbl.dirty.equals(1))).get();
  }

  /// 按服务端 id 查找本地 outfit（不过滤软删）
  Future<OutfitData?> getOutfitByServerId(int serverId) async {
    return await (select(outfits)..where((tbl) => tbl.serverId.equals(serverId)))
        .getSingleOrNull();
  }

  /// 按本地 id 查找（不过滤软删，供同步使用）
  Future<OutfitData?> getOutfitByIdRaw(int id) async {
    return await (select(outfits)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// 标记 outfit 已同步：清 dirty，可选回填 serverId
  Future<void> markOutfitSynced(int id, {int? serverId}) async {
    await (update(outfits)..where((tbl) => tbl.id.equals(id))).write(
      OutfitsCompanion(
        dirty: const Value(0),
        serverId: serverId != null ? Value(serverId) : const Value.absent(),
      ),
    );
  }

  /// 从远端插入一条新 outfit（已带 serverId，dirty=0）
  Future<int> insertRemoteOutfit({
    required int serverId,
    required int dateMs,
    required String description,
    required int createdAtMs,
    required int updatedAtMs,
    required bool isDeleted,
  }) async {
    return await into(outfits).insert(OutfitsCompanion.insert(
      date: dateMs,
      description: description,
      createdAt: createdAtMs,
      updatedAt: updatedAtMs,
      isDeleted: Value(isDeleted ? 1 : 0),
      serverId: Value(serverId),
      dirty: const Value(0),
    ));
  }

  /// 用远端数据覆盖本地 outfit（last-write-wins，dirty=0）
  Future<void> updateOutfitFromRemote(
    int localId, {
    required int dateMs,
    required String description,
    required int updatedAtMs,
    required bool isDeleted,
  }) async {
    await (update(outfits)..where((tbl) => tbl.id.equals(localId))).write(
      OutfitsCompanion(
        date: Value(dateMs),
        description: Value(description),
        updatedAt: Value(updatedAtMs),
        isDeleted: Value(isDeleted ? 1 : 0),
        dirty: const Value(0),
      ),
    );
  }

  /// 永久删除 outfit（物理删除）
  Future<bool> permanentlyDeleteOutfit(int id) async {
    // 先删除关联的 tags
    await (delete(outfitTags)..where((tbl) => tbl.outfitId.equals(id))).go();
    
    // 删除 outfit
    final result = await (delete(outfits)..where((tbl) => tbl.id.equals(id))).go();
    return result > 0;
  }

  /// 账号删除后调用：服务端数据已清空，serverId 全部失效。
  /// 置回"本地未同步"状态，换新账号登录时整体重新推送。
  Future<void> resetSyncMetadata() async {
    await update(outfits).write(const OutfitsCompanion(
      serverId: Value(null),
      dirty: Value(1),
    ));
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
  
  /// 获取指定月份的所有 outfits（用于日历显示）
  Future<List<OutfitData>> getOutfitsByMonth(int year, int month) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);
    final startTimestamp = startDate.millisecondsSinceEpoch;
    final endTimestamp = endDate.millisecondsSinceEpoch;

    return await (select(outfits)
          ..where((tbl) =>
              tbl.date.isBiggerOrEqualValue(startTimestamp) &
              tbl.date.isSmallerOrEqualValue(endTimestamp) &
              tbl.isDeleted.equals(0))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .get();
  }
  
  /// 获取某天的 outfits 数量
  Future<int> getOutfitCountByDay(DateTime day) async {
    final startTimestamp = DateTime(day.year, day.month, day.day).millisecondsSinceEpoch;
    final endTimestamp = DateTime(day.year, day.month, day.day, 23, 59, 59).millisecondsSinceEpoch;
    
    final count = await (selectOnly(outfits)
          ..addColumns([outfits.id.count()])
          ..where(
              outfits.date.isBiggerOrEqualValue(startTimestamp) &
              outfits.date.isSmallerOrEqualValue(endTimestamp) &
              outfits.isDeleted.equals(0)))
        .getSingle();
    
    return count.read(outfits.id.count()) ?? 0;
  }
  
  /// 获取总记录数
  Future<int> getTotalCount() async {
    final count = await (selectOnly(outfits)
          ..addColumns([outfits.id.count()])
          ..where(outfits.isDeleted.equals(0)))
        .getSingle();
    
    return count.read(outfits.id.count()) ?? 0;
  }
  
  /// 获取标签使用频率统计
  Future<Map<String, int>> getTagUsageStats() async {
    // 查询 outfit_tags 并按 tagId 分组统计
    final query = selectOnly(outfitTags)
      ..addColumns([outfitTags.tagId, outfitTags.tagId.count()])
      ..groupBy([outfitTags.tagId]);

    final results = await query.get();

    // 获取 tagId -> count 映射
    final tagIdCountMap = <int, int>{};
    for (final row in results) {
      final tagId = row.read(outfitTags.tagId);
      final count = row.read(outfitTags.tagId.count()) ?? 0;
      if (tagId != null) {
        tagIdCountMap[tagId] = count;
      }
    }

    // 获取所有标签名称
    final tagNameMap = <int, String>{};
    if (tagIdCountMap.isNotEmpty) {
      final tagsResult = await (select(db.tags)
            ..where((tbl) => tbl.id.isIn(tagIdCountMap.keys.toList())))
          .get();
      for (final tag in tagsResult) {
        tagNameMap[tag.id] = tag.name;
      }
    }

    // 构建 tagName -> count 映射
    final result = <String, int>{};
    for (final entry in tagIdCountMap.entries) {
      final tagName = tagNameMap[entry.key];
      if (tagName != null) {
        result[tagName] = entry.value;
      }
    }

    return result;
  }
}
