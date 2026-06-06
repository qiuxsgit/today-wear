import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:today_wear/api/api_client.dart';
import 'package:today_wear/api/weather_api.dart';
import 'package:today_wear/services/weather_service.dart';

Position pos(double lat, double lon) => Position(
      latitude: lat,
      longitude: lon,
      timestamp: DateTime(2026, 6, 6),
      accuracy: 100,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );

WeatherApi apiReturning(int Function() counter, {int status = 200}) {
  final mock = MockClient((req) async {
    counter();
    if (status != 200) {
      return http.Response(
          jsonEncode({'data': null, 'error': {'code': 'weather_unavailable', 'message': ''}}),
          status);
    }
    return http.Response(
        jsonEncode({
          'data': {'city': '台北', 'text': '多云', 'temp': 24, 'icon': '101', 'obsTime': 't'}
        }),
        200,
        headers: {'content-type': 'application/json'});
  });
  return WeatherApi(ApiClient.forTesting(mock));
}

void main() {
  test('成功加载 → success 且数据解析正确', () async {
    var calls = 0;
    final svc = WeatherService.forTesting(
        apiReturning(() => calls++), () async => pos(25.03, 121.56));
    await svc.load();
    expect(svc.status, WeatherStatus.success);
    expect(svc.weather!.city, '台北');
    expect(svc.weather!.temp, 24);
    expect(calls, 1);
  });

  test('30 分钟内同坐标再次 load 不再请求', () async {
    var calls = 0;
    final svc = WeatherService.forTesting(
        apiReturning(() => calls++), () async => pos(25.03, 121.56));
    svc.now = () => DateTime(2026, 6, 6, 10, 0);
    await svc.load();
    svc.now = () => DateTime(2026, 6, 6, 10, 20);
    await svc.load();
    expect(calls, 1);
  });

  test('缓存过期后再次 load 重新请求', () async {
    var calls = 0;
    final svc = WeatherService.forTesting(
        apiReturning(() => calls++), () async => pos(25.03, 121.56));
    svc.now = () => DateTime(2026, 6, 6, 10, 0);
    await svc.load();
    svc.now = () => DateTime(2026, 6, 6, 10, 31);
    await svc.load();
    expect(calls, 2);
  });

  test('坐标位移超阈值 → 30 分钟内也重新请求', () async {
    var calls = 0;
    var current = pos(25.03, 121.56);
    final svc = WeatherService.forTesting(
        apiReturning(() => calls++), () async => current);
    svc.now = () => DateTime(2026, 6, 6, 10, 0);
    await svc.load();
    current = pos(25.10, 121.56); // 0.07° > 0.02°
    svc.now = () => DateTime(2026, 6, 6, 10, 5);
    await svc.load();
    expect(calls, 2);
  });

  test('权限拒绝 → permissionDenied', () async {
    final svc = WeatherService.forTesting(apiReturning(() => 0),
        () async => throw PermissionDeniedException('denied'));
    await svc.load();
    expect(svc.status, WeatherStatus.permissionDenied);
  });

  test('服务端 5xx → failed', () async {
    var calls = 0;
    final svc = WeatherService.forTesting(
        apiReturning(() => calls++, status: 502), () async => pos(25.03, 121.56));
    await svc.load();
    expect(svc.status, WeatherStatus.failed);
  });

  test('已有数据时刷新失败保持旧数据展示', () async {
    var calls = 0;
    var fail = false;
    final mock = MockClient((req) async {
      calls++;
      if (fail) return http.Response('oops', 502);
      return http.Response(
          jsonEncode({
            'data': {'city': '台北', 'text': '多云', 'temp': 24, 'icon': '101', 'obsTime': 't'}
          }),
          200,
          headers: {'content-type': 'application/json'});
    });
    final svc = WeatherService.forTesting(
        WeatherApi(ApiClient.forTesting(mock)), () async => pos(25.03, 121.56));
    svc.now = () => DateTime(2026, 6, 6, 10, 0);
    await svc.load();
    fail = true;
    svc.now = () => DateTime(2026, 6, 6, 11, 0);
    await svc.load();
    expect(svc.status, WeatherStatus.success); // 静默失败，保留旧数据
    expect(svc.weather!.city, '台北');
    expect(calls, 2);
  });

  test('已有数据后权限被收回 → 保留旧数据不改状态', () async {
    var calls = 0;
    var denied = false;
    final svc = WeatherService.forTesting(
        apiReturning(() => calls++),
        () async => denied
            ? throw PermissionDeniedException('denied')
            : pos(25.03, 121.56));
    svc.now = () => DateTime(2026, 6, 6, 10, 0);
    await svc.load();
    denied = true;
    svc.now = () => DateTime(2026, 6, 6, 11, 0);
    await svc.load();
    expect(svc.status, WeatherStatus.success); // 静默保留旧数据
    expect(svc.weather!.city, '台北');
  });

  test('onTapDenied 非永久拒绝 → 强制重新加载', () async {
    var calls = 0;
    var denied = true;
    final svc = WeatherService.forTesting(
        apiReturning(() => calls++),
        () async => denied
            ? throw PermissionDeniedException('denied')
            : pos(25.03, 121.56));
    await svc.load();
    expect(svc.status, WeatherStatus.permissionDenied);
    denied = false; // 用户在弹窗里允许了
    await svc.onTapDenied();
    expect(svc.status, WeatherStatus.success);
    expect(calls, 1);
  });
}
