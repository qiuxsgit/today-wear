import '../models/weather.dart';
import '../services/locale_service.dart';
import 'api_client.dart';

/// 天气 API（公开，无需登录态）
class WeatherApi {
  final ApiClient _client;
  WeatherApi([ApiClient? client]) : _client = client ?? ApiClient.instance;

  /// 按坐标取实时天气，lang 取当前 API 语言标签（zh-CN/zh-TW/en/ja/ko）。
  Future<Weather> fetchNow(double lat, double lon) async {
    final data = await _client.get('/weather/now', query: {
      'lat': lat.toStringAsFixed(4),
      'lon': lon.toStringAsFixed(4),
      'lang': LocaleService.apiLanguageTag,
    });
    return Weather.fromJson((data as Map).cast<String, dynamic>());
  }

  /// 按当前观测取穿衣文案（服务端 30 分钟缓存；失败由调用方静默降级）。
  Future<String> fetchTip(Weather w) async {
    final data = await _client.get('/weather/tip', query: {
      'city': w.city,
      'text': w.text,
      'temp': w.temp.toString(),
      'lang': LocaleService.apiLanguageTag,
    });
    return ((data as Map)['tip'] as String?) ?? '';
  }
}
