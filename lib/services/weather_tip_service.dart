import 'package:flutter/foundation.dart';

import '../api/weather_api.dart';
import '../models/weather.dart';
import 'locale_service.dart';
import 'log_service.dart';
import 'weather_service.dart';

/// 穿衣文案服务：天气加载成功后向服务端取一句文案替换占位行。
///
/// - 同一次观测（obsTime+内容+语言）成败只请求一次，失败不重试——等下次
///   天气刷新出新观测再试，避免重试风暴；
/// - 任何失败静默：tip 保持 null，UI 显示占位文案；
/// - 纯内存，不进 Drift（与 Weather 同理，瞬时数据）。
class WeatherTipService extends ChangeNotifier {
  WeatherTipService._()
      : _api = WeatherApi(),
        _weatherService = WeatherService.instance {
    _weatherService.addListener(_onWeatherChanged);
  }

  static final WeatherTipService instance = WeatherTipService._();

  @visibleForTesting
  WeatherTipService.forTesting(this._api, this._weatherService) {
    _weatherService.addListener(_onWeatherChanged);
  }

  final WeatherApi _api;
  final WeatherService _weatherService;

  String? _tip;
  String _requestedKey = ''; // 已请求过的观测标识（成败皆记，防重试风暴）
  bool _loading = false;

  /// 进行中的拉取（测试同步用）。
  @visibleForTesting
  Future<void>? inflight;

  /// 当前文案；null 时 UI 显示占位文案。
  String? get tip => _tip;

  String _keyOf(Weather w) =>
      '${w.obsTime}|${w.city}|${w.text}|${w.temp}|${LocaleService.apiLanguageTag}';

  void _onWeatherChanged() {
    final w = _weatherService.weather;
    if (_weatherService.status != WeatherStatus.success || w == null) return;
    final key = _keyOf(w);
    if (_loading || key == _requestedKey) return;
    inflight = _fetch(w, key);
  }

  Future<void> _fetch(Weather w, String key) async {
    _loading = true;
    _requestedKey = key;
    _tip = null; // 旧文案不再匹配当前天气，先回占位
    notifyListeners();
    try {
      final tip = await _api.fetchTip(w);
      if (tip.isNotEmpty) _tip = tip;
    } catch (e) {
      LogService.instance.error('WeatherTip', 'fetch failed', e);
      // 静默：tip 保持 null，等下次观测再试
    } finally {
      _loading = false;
      notifyListeners();
    }
    _onWeatherChanged(); // 飞行中天气已变则补拉（key 未变时直接返回）
  }
}
