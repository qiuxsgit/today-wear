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
}
