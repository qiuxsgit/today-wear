import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:today_wear/database/database.dart';
import 'package:today_wear/repositories/outfit_repository.dart';

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
  late OutfitRepository repository;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('today_wear_test');
    PathProviderPlatform.instance = _FakePathProvider(tempDir.path);
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = OutfitRepository(db);
  });

  tearDown(() async {
    await db.close();
    tempDir.deleteSync(recursive: true);
  });

  Future<int> insertOutfit(int daysAgo) async {
    final date =
        DateTime(2026, 6, 1).subtract(Duration(days: daysAgo)).millisecondsSinceEpoch;
    return db.outfitDao.insertOutfit(OutfitsCompanion.insert(
      date: date,
      description: 'outfit-$daysAgo',
      createdAt: date,
      updatedAt: date,
    ));
  }

  group('getOutfitsByTag 分页', () {
    test('limit/offset 分页且按日期倒序，排序与全量列表一致', () async {
      final tag = await db.tagDao.getOrCreateTag('通勤');
      final taggedIds = <int>[];
      for (int i = 0; i < 12; i++) {
        final id = await insertOutfit(i); // i 越小日期越新
        await db.tagDao.setOutfitTags(id, [tag.id]);
        taggedIds.add(id);
      }
      // 一条无标签记录，不应出现在筛选结果中
      await insertOutfit(20);

      final page1 = await repository.getOutfitsByTag('通勤', limit: 5, offset: 0);
      final page2 = await repository.getOutfitsByTag('通勤', limit: 5, offset: 5);
      final page3 = await repository.getOutfitsByTag('通勤', limit: 5, offset: 10);

      expect(page1.length, 5);
      expect(page2.length, 5);
      expect(page3.length, 2);

      // 按日期倒序且页间无重叠
      final all = [...page1, ...page2, ...page3];
      for (int i = 1; i < all.length; i++) {
        expect(all[i - 1].date.isAfter(all[i].date), isTrue);
      }
      expect(all.map((o) => o.id).toSet().length, 12);
      expect(all.map((o) => o.id).toSet(), taggedIds.toSet());
    });

    test('不存在的标签返回空列表', () async {
      expect(await repository.getOutfitsByTag('不存在', limit: 10), isEmpty);
    });
  });

  group('photos 映射', () {
    test('未下载的云端图 localPath 为 null，photoPaths 仅含本地图', () async {
      final id = await insertOutfit(0);
      await db.imageDao.insertRemoteImage(
        outfitId: id,
        imagePath: 'images/20260601/${id}_0.jpg',
        displayOrder: 0,
        serverImageId: 101,
      );
      await db.imageDao.insertRemoteImage(
        outfitId: id,
        displayOrder: 1,
        serverImageId: 102, // 未下载：imagePath 为 null
      );

      final outfit = await repository.getOutfitById(id);
      expect(outfit, isNotNull);
      expect(outfit!.photos.length, 2);
      expect(outfit.photos[0].localPath, isNotNull);
      expect(outfit.photos[0].serverImageId, 101);
      expect(outfit.photos[1].localPath, isNull);
      expect(outfit.photos[1].serverImageId, 102);
      // photoPaths 兼容 getter 只返回已下载的本地路径
      expect(outfit.photoPaths.length, 1);
    });
  });
}
