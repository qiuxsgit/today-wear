import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';
import '../../theme/tag_colors.dart';

part 'tag_dao.g.dart';

/// Tag 数据访问对象
@DriftAccessor(tables: [Tags, OutfitTags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(super.db);

  /// 获取所有 tags
  Future<List<TagData>> getAllTags() async {
    return await select(tags).get();
  }

  /// 根据名称查找 tag
  Future<TagData?> getTagByName(String name) async {
    return await (select(tags)..where((tbl) => tbl.name.equals(name)))
        .getSingleOrNull();
  }

  /// 获取使用该 tag 的穿搭数量
  Future<int> getTagUsageCount(int tagId) async {
    final count = await (selectOnly(outfitTags)
          ..addColumns([outfitTags.outfitId.count()])
          ..where(outfitTags.tagId.equals(tagId)))
        .getSingle();
    return count.read(outfitTags.outfitId.count()) ?? 0;
  }

  /// 更新 tag 名称（新名称不能与已有 tag 重复）
  Future<bool> updateTagName(int tagId, String newName) async {
    return updateTag(tagId, newName, null);
  }

  /// 更新 tag 名称与颜色（名称不能与已有 tag 重复，color 为 null 则不更新颜色）
  Future<bool> updateTag(int tagId, String newName, String? newColor) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return false;
    final existing = await getTagByName(trimmed);
    if (existing != null && existing.id != tagId) return false;
    final companion = TagsCompanion(
      name: Value(trimmed),
      color: newColor != null ? Value(newColor) : const Value.absent(),
      dirty: const Value(1),
    );
    final result = await (update(tags)..where((tbl) => tbl.id.equals(tagId)))
        .write(companion);
    return result > 0;
  }

  /// 新建 tag（名称不能与已有 tag 重复），成功返回 true
  Future<bool> createTag(String name, String color) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return false;
    final existing = await getTagByName(trimmed);
    if (existing != null) return false;
    await into(tags).insert(TagsCompanion.insert(
      name: trimmed,
      color: Value(color),
    ));
    return true;
  }

  /// 删除 tag：先从所有穿搭中移除该标签，再删除 tag
  Future<void> deleteTagAndRemoveFromAllOutfits(int tagId) async {
    await (delete(outfitTags)..where((tbl) => tbl.tagId.equals(tagId))).go();
    await (delete(tags)..where((tbl) => tbl.id.equals(tagId))).go();
  }

  /// 根据名称查找或创建 tag（新建时使用默认颜色）
  Future<TagData> getOrCreateTag(String name) async {
    final existing = await getTagByName(name);
    if (existing != null) {
      return existing;
    }
    final companion = TagsCompanion.insert(
      name: name,
      color: Value(TagColors.defaultColorHex),
    );
    final id = await into(tags).insert(companion);
    return TagData(
      id: id,
      name: name,
      color: TagColors.defaultColorHex,
      serverId: null,
      dirty: 1,
      ver: 0,
    );
  }

  // --- 云同步辅助 ---------------------------------------------------------

  /// 获取所有待推送（dirty=1）的标签
  Future<List<TagData>> getDirtyTags() async {
    return await (select(tags)..where((tbl) => tbl.dirty.equals(1))).get();
  }

  /// 按服务端 id 查找标签
  Future<TagData?> getTagByServerId(int serverId) async {
    return await (select(tags)..where((tbl) => tbl.serverId.equals(serverId)))
        .getSingleOrNull();
  }

  /// 标记标签已同步：清 dirty，可选回填 serverId 与服务端 ver
  Future<void> markTagSynced(int id, {int? serverId, int? ver}) async {
    await (update(tags)..where((tbl) => tbl.id.equals(id))).write(
      TagsCompanion(
        dirty: const Value(0),
        serverId: serverId != null ? Value(serverId) : const Value.absent(),
        ver: ver != null ? Value(ver) : const Value.absent(),
      ),
    );
  }

  /// 按本地 id 查找标签
  Future<TagData?> getTagById(int id) async {
    return await (select(tags)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// 仅更新乐观锁版本号（冲突裁决"保留本机"时把 base 提到服务端最新，不影响 dirty）
  Future<void> setTagVer(int id, int ver) async {
    await (update(tags)..where((tbl) => tbl.id.equals(id)))
        .write(TagsCompanion(ver: Value(ver)));
  }

  /// 回填某标签的 serverId（按本地 id）
  Future<void> setTagServerId(int id, int serverId) async {
    await (update(tags)..where((tbl) => tbl.id.equals(id)))
        .write(TagsCompanion(serverId: Value(serverId)));
  }

  /// 从远端插入或更新标签（按 name 匹配，dirty=0）。
  /// [ver] 为 null 时不覆盖既有 ver（如 outfit 内嵌标签无 ver 信息，
  /// 由每轮同步的 /tags 拉取兜底回填）。
  Future<void> upsertRemoteTag({
    required int serverId,
    required String name,
    required String color,
    int? ver,
  }) async {
    final existing = await getTagByName(name);
    if (existing != null) {
      await (update(tags)..where((tbl) => tbl.id.equals(existing.id))).write(
        TagsCompanion(
          color: Value(color),
          serverId: Value(serverId),
          dirty: const Value(0),
          ver: ver != null ? Value(ver) : const Value.absent(),
        ),
      );
    } else {
      await into(tags).insert(TagsCompanion.insert(
        name: name,
        color: Value(color),
        serverId: Value(serverId),
        dirty: const Value(0),
        ver: Value(ver ?? 0),
      ));
    }
  }

  /// 账号删除后调用：服务端数据已清空，serverId 全部失效。
  /// 置回"本地未同步"状态，换新账号登录时整体重新推送。
  Future<void> resetSyncMetadata() async {
    await update(tags).write(const TagsCompanion(
      serverId: Value(null),
      dirty: Value(1),
    ));
  }

  /// 插入 tag
  Future<int> insertTag(TagsCompanion tag) async {
    return await into(tags).insert(tag);
  }

  /// 删除 tag（如果没有任何 outfit 使用）
  Future<bool> deleteTagIfUnused(int tagId) async {
    // 检查是否有 outfit 使用此 tag
    final count = await (selectOnly(outfitTags)
          ..addColumns([outfitTags.outfitId.count()])
          ..where(outfitTags.tagId.equals(tagId)))
        .getSingle();
    
    final usageCount = count.read(outfitTags.outfitId.count()) ?? 0;
    if (usageCount > 0) {
      return false; // 仍有使用，不能删除
    }
    
    final result = await (delete(tags)..where((tbl) => tags.id.equals(tagId))).go();
    return result > 0;
  }

  /// 获取 outfit 的所有 tags
  Future<List<TagData>> getTagsByOutfitId(int outfitId) async {
    final query = select(tags).join([
      innerJoin(outfitTags, outfitTags.tagId.equalsExp(tags.id)),
    ])..where(outfitTags.outfitId.equals(outfitId));
    
    final results = await query.get();
    return results.map((row) => row.readTable(tags)).toList();
  }

  /// 为 outfit 添加 tag
  Future<void> addTagToOutfit(int outfitId, int tagId) async {
    final companion = OutfitTagsCompanion.insert(
      outfitId: outfitId,
      tagId: tagId,
    );
    try {
      await into(outfitTags).insert(companion);
    } catch (e) {
      // 忽略重复插入错误
    }
  }

  /// 移除 outfit 的 tag
  Future<void> removeTagFromOutfit(int outfitId, int tagId) async {
    await (delete(outfitTags)
          ..where((tbl) =>
              tbl.outfitId.equals(outfitId) & tbl.tagId.equals(tagId)))
        .go();
  }

  /// 设置 outfit 的所有 tags（先删除旧的，再添加新的）
  Future<void> setOutfitTags(int outfitId, List<int> tagIds) async {
    // 删除旧的关联
    await (delete(outfitTags)..where((tbl) => tbl.outfitId.equals(outfitId)))
        .go();

    // 添加新的关联
    for (final tagId in tagIds) {
      final companion = OutfitTagsCompanion.insert(
        outfitId: outfitId,
        tagId: tagId,
      );
      await into(outfitTags).insert(companion);
    }
  }

  /// 服务端写入成功后同步更新本地记录，清 dirty
  Future<void> updateTagFromServer(
      int id, String name, String color, int ver) async {
    await (update(tags)..where((tbl) => tbl.id.equals(id))).write(
      TagsCompanion(
        name: Value(name),
        color: Value(color),
        ver: Value(ver),
        dirty: const Value(0),
      ),
    );
  }

  /// 删除已同步（dirty=0）但服务端已不存在的本地标签及其穿搭关联
  Future<void> deleteRemoteDeletedTags(List<int> serverIds) async {
    final synced = await (select(tags)
          ..where((tbl) => tbl.serverId.isNotNull() & tbl.dirty.equals(0)))
        .get();
    for (final tag in synced) {
      if (!serverIds.contains(tag.serverId)) {
        await (delete(outfitTags)..where((tbl) => tbl.tagId.equals(tag.id)))
            .go();
        await (delete(tags)..where((tbl) => tbl.id.equals(tag.id))).go();
      }
    }
  }
}
