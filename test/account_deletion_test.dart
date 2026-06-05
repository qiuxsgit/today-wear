import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:today_wear/api/api_client.dart';
import 'package:today_wear/api/api_exception.dart';
import 'package:today_wear/api/user_api.dart';
import 'package:today_wear/database/database.dart';

void main() {
  group('UserApi.deleteAccount', () {
    test('发送 DELETE /users/me 携带 password body，204 视为成功', () async {
      late http.Request captured;
      final client = ApiClient.forTesting(MockClient((req) async {
        captured = req;
        return http.Response('', 204);
      }));
      await UserApi(client).deleteAccount('secret-pw');

      expect(captured.method, 'DELETE');
      expect(captured.url.path, endsWith('/users/me'));
      expect(jsonDecode(captured.body), {'password': 'secret-pw'});
      expect(captured.headers['Content-Type'], startsWith('application/json'));
    });

    test('401 invalid_credentials 抛 UnauthorizedException 且不触发 onUnauthorized', () async {
      var unauthorizedCalls = 0;
      final client = ApiClient.forTesting(MockClient((req) async {
        return http.Response(
          jsonEncode({
            'data': null,
            'error': {'code': 'invalid_credentials', 'message': 'bad'},
          }),
          401,
          headers: {'content-type': 'application/json'},
        );
      }))
        ..onUnauthorized = () => unauthorizedCalls++;

      await expectLater(
        UserApi(client).deleteAccount('wrong'),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(unauthorizedCalls, 0, reason: '密码错误不得清会话');
    });

    test('401 unauthorized（会话失效）仍触发 onUnauthorized', () async {
      var unauthorizedCalls = 0;
      final client = ApiClient.forTesting(MockClient((req) async {
        return http.Response(
          jsonEncode({
            'data': null,
            'error': {'code': 'unauthorized', 'message': 'expired'},
          }),
          401,
          headers: {'content-type': 'application/json'},
        );
      }))
        ..onUnauthorized = () => unauthorizedCalls++;

      await expectLater(
        UserApi(client).deleteAccount('any'),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(unauthorizedCalls, 1);
    });
  });

  group('重置同步元数据', () {
    late AppDatabase db;

    setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('outfits/tags/images 的 serverId 清空、dirty 置 1', () async {
      final now = DateTime(2026, 6, 5).millisecondsSinceEpoch;

      // 造一条"已同步"的 outfit
      final outfitId = await db.outfitDao.insertOutfit(OutfitsCompanion.insert(
        date: now,
        description: 'test outfit',
        createdAt: now,
        updatedAt: now,
      ));
      await db.outfitDao.markOutfitSynced(outfitId, serverId: 99);

      // 造一条"已同步"的 tag
      final tagId = await db.tagDao.insertTag(TagsCompanion.insert(name: 'test-tag'));
      await db.tagDao.markTagSynced(tagId, serverId: 88);

      // 造一条"已同步"的 image（serverImageId 已回填）
      final imageId = await db.imageDao.insertImage(OutfitImagesCompanion.insert(
        outfitId: outfitId,
        displayOrder: 0,
      ));
      await db.imageDao.setServerImageId(imageId, 77);

      // 验证初始状态：serverId 已回填、dirty=0
      final outfitBefore = await db.outfitDao.getOutfitById(outfitId);
      expect(outfitBefore!.serverId, 99);
      expect(outfitBefore.dirty, 0);

      // 执行重置
      await db.outfitDao.resetSyncMetadata();
      await db.tagDao.resetSyncMetadata();
      await db.imageDao.resetServerImageIds();

      // 验证 outfit：serverId 清空，dirty 置 1
      final outfit = await db.outfitDao.getOutfitById(outfitId);
      expect(outfit!.serverId, isNull);
      expect(outfit.dirty, 1);

      // 验证 tag：serverId 清空，dirty 置 1
      final tags = await db.tagDao.getAllTags();
      expect(tags.single.serverId, isNull);
      expect(tags.single.dirty, 1);

      // 验证 image：serverImageId 清空
      final images = await db.imageDao.getImagesByOutfitId(outfitId);
      expect(images.single.serverImageId, isNull);
    });
  });
}
