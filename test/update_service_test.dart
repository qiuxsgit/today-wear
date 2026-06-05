import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:today_wear/api/version_api.dart';
import 'package:today_wear/services/update_service.dart';

class _FakeVersionApi extends VersionApi {
  _FakeVersionApi(this.result);
  final VersionCheckResult result;
  int calls = 0;

  @override
  Future<VersionCheckResult> check(
      {required String channel, required int versionCode}) async {
    calls++;
    return result;
  }
}

class _ThrowingVersionApi extends VersionApi {
  @override
  Future<VersionCheckResult> check(
      {required String channel, required int versionCode}) async {
    throw Exception('network down');
  }
}

VersionCheckResult _result({bool force = false}) => VersionCheckResult(
      hasUpdate: true,
      forceUpdate: force,
      latestVersionName: '2.1.0',
      latestVersionCode: 5,
      notes: 'notes',
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  UpdateService svc(VersionApi api) =>
      UpdateService.forTesting(api: api, channel: 'play', buildNumber: 2);

  test('无更新 → 启动检查返回 null', () async {
    final api = _FakeVersionApi(const VersionCheckResult(
        hasUpdate: false,
        forceUpdate: false,
        latestVersionName: '',
        latestVersionCode: 0,
        notes: ''));
    expect(await svc(api).checkOnLaunch(), isNull);
  });

  test('普通更新仅弹一次：同版本第二次启动不再返回', () async {
    final api = _FakeVersionApi(_result());
    final s = svc(api);
    expect(await s.checkOnLaunch(), isNotNull);
    expect(await s.checkOnLaunch(), isNull);
  });

  test('强更每次启动都返回', () async {
    final api = _FakeVersionApi(_result(force: true));
    final s = svc(api);
    expect(await s.checkOnLaunch(), isNotNull);
    expect(await s.checkOnLaunch(), isNotNull);
  });

  test('接口异常 → 启动检查静默返回 null', () async {
    expect(await svc(_ThrowingVersionApi()).checkOnLaunch(), isNull);
  });

  test('手动检查不受仅弹一次限制', () async {
    final api = _FakeVersionApi(_result());
    final s = svc(api);
    await s.checkOnLaunch(); // 已记录 latestVersionCode
    final manual = await s.checkManually();
    expect(manual, isNotNull);
    expect(manual!.hasUpdate, isTrue);
  });

  test('不支持的平台（channel=null）→ 两种检查都返回 null 且不调接口', () async {
    final api = _FakeVersionApi(_result());
    final s = UpdateService.forTesting(api: api, channel: null, buildNumber: 2);
    expect(await s.checkOnLaunch(), isNull);
    expect(await s.checkManually(), isNull);
    expect(api.calls, 0);
  });
}
