import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../api/weather_api.dart';
import '../models/weather.dart';
import 'log_service.dart';

/// 天气卡片的渲染状态
enum WeatherStatus { loading, success, permissionDenied, failed }

/// 天气服务：定位 → 服务端天气接口 → 内存缓存 30 分钟。
///
/// - 缓存未过期且坐标未大幅移动时不发请求；
/// - 已有数据时的刷新失败静默保留旧数据（状态保持 success）；
/// - macOS 仅调试构建，不接定位，直接 failed 态。
class WeatherService extends ChangeNotifier {
  WeatherService._()
      : _api = WeatherApi(),
        _getPosition = _currentPosition;

  static final WeatherService instance = WeatherService._();

  @visibleForTesting
  WeatherService.forTesting(this._api, this._getPosition);

  final WeatherApi _api;
  final Future<Position> Function() _getPosition;

  /// 可注入时钟（测试用）
  DateTime Function() now = DateTime.now;

  static const Duration cacheTtl = Duration(minutes: 30);

  /// 视为"换了城市"的坐标位移阈值（度，约 2km）
  static const double moveThreshold = 0.02;

  WeatherStatus _status = WeatherStatus.loading;
  Weather? _weather;
  bool _deniedForever = false;
  DateTime? _fetchedAt;
  double? _lat, _lon;
  bool _loading = false;

  WeatherStatus get status => _status;
  Weather? get weather => _weather;

  static Future<Position> _currentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationServiceDisabledException();
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw PermissionDeniedException(
          permission == LocationPermission.deniedForever ? 'forever' : 'denied');
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low, // 城市级精度足够
        timeLimit: Duration(seconds: 8),
      ),
    );
  }

  /// 加载/刷新天气。[force] 为 true 时忽略 30 分钟缓存（手动重试、语言切换）。
  Future<void> load({bool force = false}) async {
    if (_loading) return;
    // macOS 仅调试用，不接定位；但 flutter test 运行时 FLUTTER_TEST 环境变量存在，
    // 需跳过此分支，否则所有测试用例在 macOS 主机上均走 failed 态。
    if (!kIsWeb &&
        Platform.isMacOS &&
        !Platform.environment.containsKey('FLUTTER_TEST')) {
      _status = WeatherStatus.failed;
      notifyListeners();
      return;
    }
    _loading = true;
    if (_weather == null && _status != WeatherStatus.loading) {
      _status = WeatherStatus.loading;
      notifyListeners();
    }
    try {
      final p = await _getPosition();
      final moved = _lat == null ||
          (p.latitude - _lat!).abs() > moveThreshold ||
          (p.longitude - _lon!).abs() > moveThreshold;
      final fresh =
          _fetchedAt != null && now().difference(_fetchedAt!) < cacheTtl;
      if (!force && fresh && !moved && _weather != null) {
        _status = WeatherStatus.success;
        return; // finally 里 notify
      }
      final w = await _api.fetchNow(p.latitude, p.longitude);
      _weather = w;
      _fetchedAt = now();
      _lat = p.latitude;
      _lon = p.longitude;
      _deniedForever = false;
      _status = WeatherStatus.success;
    } on PermissionDeniedException catch (e) {
      _deniedForever = e.message == 'forever';
      if (_weather == null) _status = WeatherStatus.permissionDenied;
    } on LocationServiceDisabledException {
      if (_weather == null) _status = WeatherStatus.permissionDenied;
    } catch (e) {
      LogService.instance.error('Weather', 'load failed', e);
      if (_weather == null) _status = WeatherStatus.failed;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// permissionDenied 态点击卡片：永久拒绝跳系统设置，否则重新走权限弹窗。
  Future<void> onTapDenied() async {
    if (_deniedForever) {
      await Geolocator.openAppSettings();
      return;
    }
    await load(force: true);
  }
}
