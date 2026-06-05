import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:today_wear/database/database.dart';

class _FakePathProvider extends PathProviderPlatform {
  _FakePathProvider(this.path);
  final String path;

  @override
  Future<String?> getApplicationDocumentsPath() async => path;

  @override
  Future<String?> getTemporaryPath() async => path;

  @override
  Future<String?> getApplicationSupportPath() async => path;
}

void main() {
  late Directory tempDir;
  late AppDatabase db;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('today_wear_ver_test');
    PathProviderPlatform.instance = _FakePathProvider(tempDir.path);
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
    tempDir.deleteSync(recursive: true);
  });

  Future<int> insertLocalOutfit() => db.outfitDao.insertOutfit(
        OutfitsCompanion.insert(
          date: 1,
          description: 'x',
          createdAt: 1,
          updatedAt: 1,
        ),
      );

  group('outfit ver 管道', () {
    test('insertRemoteOutfit 落 ver,dirty=0', () async {
      final id = await db.outfitDao.insertRemoteOutfit(
        serverId: 10,
        dateMs: 1,
        description: 'x',
        createdAtMs: 1,
        updatedAtMs: 1,
        isDeleted: false,
        ver: 3,
      );
      final row = await db.outfitDao.getOutfitById(id);
      expect(row!.ver, 3);
      expect(row.dirty, 0);
    });

    test('updateOutfitFromRemote 覆盖 ver', () async {
      final id = await db.outfitDao.insertRemoteOutfit(
        serverId: 10,
        dateMs: 1,
        description: 'x',
        createdAtMs: 1,
        updatedAtMs: 1,
        isDeleted: false,
        ver: 3,
      );
      await db.outfitDao.updateOutfitFromRemote(
        id,
        dateMs: 2,
        description: 'y',
        updatedAtMs: 2,
        isDeleted: false,
        ver: 4,
      );
      expect((await db.outfitDao.getOutfitById(id))!.ver, 4);
    });

    test('markOutfitSynced 回填 ver 并清 dirty', () async {
      final id = await insertLocalOutfit();
      await db.outfitDao.markOutfitSynced(id, serverId: 10, ver: 1);
      final row = await db.outfitDao.getOutfitById(id);
      expect(row!.serverId, 10);
      expect(row.ver, 1);
      expect(row.dirty, 0);
    });

    test('markOutfitSynced 不传 ver 时保留原值', () async {
      final id = await insertLocalOutfit();
      await db.outfitDao.markOutfitSynced(id, serverId: 10, ver: 5);
      await db.outfitDao.markOutfitSynced(id);
      expect((await db.outfitDao.getOutfitById(id))!.ver, 5);
    });

    test('setOutfitVer 仅改 ver 不动 dirty', () async {
      final id = await insertLocalOutfit();
      await db.outfitDao.setOutfitVer(id, 7);
      final row = await db.outfitDao.getOutfitById(id);
      expect(row!.ver, 7);
      expect(row.dirty, 1);
    });
  });

  group('tag ver 管道', () {
    test('upsertRemoteTag 落 ver,再次 upsert 覆盖 ver', () async {
      await db.tagDao
          .upsertRemoteTag(serverId: 5, name: 't', color: '#AABBCC', ver: 2);
      await db.tagDao
          .upsertRemoteTag(serverId: 5, name: 't', color: '#AABBCC', ver: 3);
      final row = await db.tagDao.getTagByServerId(5);
      expect(row!.ver, 3);
      expect(row.dirty, 0);
    });

    test('markTagSynced 回填 ver 并清 dirty', () async {
      await db.tagDao.createTag('t2', '#AABBCC');
      final tag = await db.tagDao.getTagByName('t2');
      await db.tagDao.markTagSynced(tag!.id, serverId: 6, ver: 1);
      final row = await db.tagDao.getTagByServerId(6);
      expect(row!.ver, 1);
      expect(row.dirty, 0);
    });

    test('setTagVer 仅改 ver 不动 dirty', () async {
      await db.tagDao.createTag('t3', '#AABBCC');
      final tag = await db.tagDao.getTagByName('t3');
      await db.tagDao.setTagVer(tag!.id, 9);
      final row = await db.tagDao.getTagById(tag.id);
      expect(row!.ver, 9);
      expect(row.dirty, 1);
    });
  });
}
