import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:today_wear/api/api_client.dart';
import 'package:today_wear/api/weather_api.dart';
import 'package:today_wear/services/weather_service.dart';
import 'package:today_wear/services/weather_tip_service.dart';

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

/// now/tip 双端点 mock：obsTime 可变（模拟新观测），tip 可控失败。
WeatherApi buildApi({
  required void Function() onTip,
  int tipStatus = 200,
  String Function()? obsTime,
}) {
  final mock = MockClient((req) async {
    if (req.url.path.endsWith('/weather/now')) {
      return http.Response(
          jsonEncode({
            'data': {
              'city': '台北',
              'text': '多云',
              'temp': 24,
              'icon': '101',
              'obsTime': obsTime?.call() ?? 't1',
            }
          }),
          200,
          headers: {'content-type': 'application/json'});
    }
    onTip();
    if (tipStatus != 200) {
      return http.Response(
          jsonEncode({
            'data': null,
            'error': {'code': 'tip_unavailable', 'message': ''}
          }),
          tipStatus);
    }
    return http.Response(jsonEncode({'data': {'tip': '薄外套刚刚好'}}), 200,
        headers: {'content-type': 'application/json'});
  });
  return WeatherApi(ApiClient.forTesting(mock));
}

void main() {
  test('天气成功 → 拉取文案', () async {
    var tipCalls = 0;
    final api = buildApi(onTip: () => tipCalls++);
    final weather =
        WeatherService.forTesting(api, () async => pos(25.03, 121.56));
    final svc = WeatherTipService.forTesting(api, weather);
    await weather.load();
    await svc.inflight;
    expect(svc.tip, '薄外套刚刚好');
    expect(tipCalls, 1);
  });

  test('同一观测不重复请求（缓存）', () async {
    var tipCalls = 0;
    final api = buildApi(onTip: () => tipCalls++);
    final weather =
        WeatherService.forTesting(api, () async => pos(25.03, 121.56));
    final svc = WeatherTipService.forTesting(api, weather);
    await weather.load();
    await svc.inflight;
    await weather.load(force: true); // 天气刷新但 obsTime 未变
    await svc.inflight;
    expect(tipCalls, 1);
  });

  test('新观测（obsTime 变化）→ 重新拉取', () async {
    var tipCalls = 0;
    var obs = 't1';
    final api = buildApi(onTip: () => tipCalls++, obsTime: () => obs);
    final weather =
        WeatherService.forTesting(api, () async => pos(25.03, 121.56));
    final svc = WeatherTipService.forTesting(api, weather);
    await weather.load();
    await svc.inflight;
    obs = 't2';
    await weather.load(force: true);
    await svc.inflight;
    expect(tipCalls, 2);
    expect(svc.tip, '薄外套刚刚好');
  });

  test('tip 失败 → 静默 null，同一观测不重试', () async {
    var tipCalls = 0;
    final api = buildApi(onTip: () => tipCalls++, tipStatus: 502);
    final weather =
        WeatherService.forTesting(api, () async => pos(25.03, 121.56));
    final svc = WeatherTipService.forTesting(api, weather);
    await weather.load();
    await svc.inflight;
    expect(svc.tip, isNull);
    await weather.load(force: true); // 同 obsTime → 不重试
    await svc.inflight;
    expect(tipCalls, 1);
  });

  test('天气未成功（权限拒绝）→ 不请求文案', () async {
    var tipCalls = 0;
    final api = buildApi(onTip: () => tipCalls++);
    final weather = WeatherService.forTesting(
        api, () async => throw PermissionDeniedException('denied'));
    final svc = WeatherTipService.forTesting(api, weather);
    await weather.load();
    await svc.inflight;
    expect(svc.tip, isNull);
    expect(tipCalls, 0);
  });
}
