import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';
import '../../theme/tag_colors.dart';

part 'tag_dao.g.dart';

/// Tag 数据访问对象
@DriftAccessor(tables: [Tags, OutfitTags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(AppDatabase db) : super(db);

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
    );
    final result = await (update(tags)..where((tbl) => tbl.id.equals(tagId)))
        .write(companion);
    return result > 0;
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
    return TagData(id: id, name: name, color: TagColors.defaultColorHex);
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
}
