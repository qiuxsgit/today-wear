import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:today_wear/api/media_api.dart';
import 'package:today_wear/database/database.dart';
import 'package:today_wear/models/outfit.dart';
import 'package:today_wear/services/image_download_service.dart';
import 'package:today_wear/services/image_service.dart';

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

class _FakeMediaApi extends MediaApi {
  _FakeMediaApi(this.result);
  final Map<int, String> result;
  int calls = 0;

  @override
  Future<Map<int, String>> imageUrls(List<int> ids) async {
    calls++;
    return result;
  }
}

void main() {
  late Directory tempDir;
  late AppDatabase db;
  late int outfitId;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('today_wear_dl_test');
    PathProviderPlatform.instance = _FakePathProvider(tempDir.path);
    db = AppDatabase.forTesting(NativeDatabase.memory());

    final dateMs = DateTime(2026, 6, 1).millisecondsSinceEpoch;
    outfitId = await db.outfitDao.insertOutfit(OutfitsCompanion.insert(
      date: dateMs,
      description: 'cloud outfit',
      createdAt: dateMs,
      updatedAt: dateMs,
    ));
    // 云端拉取的图片元数据：无本地路径，仅 serverImageId
    await db.imageDao.insertRemoteImage(
      outfitId: outfitId,
      displayOrder: 0,
      serverImageId: 7,
    );
  });

  tearDown(() async {
    await db.close();
    tempDir.deleteSync(recursive: true);
  });

  ImageDownloadService buildService({
    required _FakeMediaApi mediaApi,
    required MockClient httpClient,
  }) {
    return ImageDownloadService.forTesting(
      db: db,
      mediaApi: mediaApi,
      images: ImageService.instance,
      httpClient: httpClient,
    );
  }

  test('首次下载落盘并回填 imagePath，二次调用不重复下载', () async {
    var downloads = 0;
    final mediaApi = _FakeMediaApi({7: 'https://gfs.test/7.jpg'});
    final svc = buildService(
      mediaApi: mediaApi,
      httpClient: MockClient((req) async {
        downloads++;
        return http.Response.bytes([1, 2, 3], 200);
      }),
    );

    final file = await svc.ensureDownloaded(7);
    expect(file, isNotNull);
    expect(await file!.exists(), isTrue);
    expect(await file.readAsBytes(), [1, 2, 3]);
    expect(downloads, 1);

    // 数据库已回填本地路径
    final record = await db.imageDao.getImageByServerId(7);
    expect(record!.imagePath, isNotNull);

    // 二次调用：直接走本地文件，不再换 URL / 下载
    final again = await svc.ensureDownloaded(7);
    expect(again, isNotNull);
    expect(downloads, 1);
    expect(mediaApi.calls, 1);
  });

  test('同 id 并发请求合并为一次下载', () async {
    var downloads = 0;
    final svc = buildService(
      mediaApi: _FakeMediaApi({7: 'https://gfs.test/7.jpg'}),
      httpClient: MockClient((req) async {
        downloads++;
        await Future.delayed(const Duration(milliseconds: 20));
        return http.Response.bytes([1, 2, 3], 200);
      }),
    );

    final results = await Future.wait([
      svc.ensureDownloaded(7),
      svc.ensureDownloaded(7),
      svc.ensureDownloaded(7),
    ]);

    expect(results.every((f) => f != null), isTrue);
    expect(downloads, 1);
  });

  test('下载失败返回 null 且不回填路径（下次仍会重试）', () async {
    final svc = buildService(
      mediaApi: _FakeMediaApi({7: 'https://gfs.test/7.jpg'}),
      httpClient: MockClient((req) async => http.Response('not found', 404)),
    );

    expect(await svc.ensureDownloaded(7), isNull);
    final record = await db.imageDao.getImageByServerId(7);
    expect(record!.imagePath, isNull);
  });

  test('换 URL 结果缺失该 id（云端已删/无权）返回 null', () async {
    final svc = buildService(
      mediaApi: _FakeMediaApi({}),
      httpClient: MockClient((req) async => http.Response.bytes([1], 200)),
    );

    expect(await svc.ensureDownloaded(7), isNull);
  });

  test('ensureAllDownloaded 批量补齐整条穿搭的未下载图', () async {
    // 第二张未下载的云端图
    await db.imageDao.insertRemoteImage(
      outfitId: outfitId,
      displayOrder: 1,
      serverImageId: 8,
    );

    var downloads = 0;
    final svc = buildService(
      mediaApi: _FakeMediaApi({
        7: 'https://gfs.test/7.jpg',
        8: 'https://gfs.test/8.jpg',
      }),
      httpClient: MockClient((req) async {
        downloads++;
        return http.Response.bytes([1, 2, 3], 200);
      }),
    );

    final files = await svc.ensureAllDownloaded(const [
      OutfitPhoto(serverImageId: 7),
      OutfitPhoto(serverImageId: 8),
    ]);

    expect(files.length, 2);
    expect(files.every((f) => f != null), isTrue);
    expect(downloads, 2);
    expect((await db.imageDao.getImageByServerId(7))!.imagePath, isNotNull);
    expect((await db.imageDao.getImageByServerId(8))!.imagePath, isNotNull);
  });
}
