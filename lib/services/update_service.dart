import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/version_api.dart';
import 'dist_channel.dart';
import 'log_service.dart';

/// 版本检查服务
///
/// - 启动静默检查 [checkOnLaunch]：失败完全静默；普通更新每个
///   latestVersionCode 仅提示一次（shared_preferences 记录）；强更每次都提示。
/// - 手动检查 [checkManually]：不受仅弹一次限制，异常向上抛由 UI toast。
/// - 比较逻辑全在服务端，客户端只读返回的布尔值。
class UpdateService {
  UpdateService._()
      : _api = VersionApi(),
        _channelOverride = null,
        _buildNumberOverride = null;

  static final UpdateService instance = UpdateService._();

  @visibleForTesting
  UpdateService.forTesting({
    required VersionApi api,
    required String? channel,
    required int buildNumber,
  })  : _api = api,
        _channelOverride = channel,
        _buildNumberOverride = buildNumber;

  final VersionApi _api;
  final String? _channelOverride;
  final int? _buildNumberOverride;

  static const String _promptedKey = 'update_last_prompted_version_code';

  /// 测试注入 channel 时直接用注入值（包括注入 null 表示不支持平台）。
  bool get _hasChannelOverride => _buildNumberOverride != null;

  String? get _channel =>
      _hasChannelOverride ? _channelOverride : DistChannel.resolve();

  Future<int> _buildNumber() async {
    if (_buildNumberOverride != null) return _buildNumberOverride;
    final info = await PackageInfo.fromPlatform();
    return int.tryParse(info.buildNumber) ?? 0;
  }

  /// 启动静默检查：需要弹窗时返回结果，否则 null。绝不抛异常。
  Future<VersionCheckResult?> checkOnLaunch() async {
    final channel = _channel;
    if (channel == null) return null;
    try {
      final res =
          await _api.check(channel: channel, versionCode: await _buildNumber());
      if (!res.hasUpdate) return null;
      if (res.forceUpdate) return res; // 强更每次启动都弹
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getInt(_promptedKey) == res.latestVersionCode) return null;
      await prefs.setInt(_promptedKey, res.latestVersionCode);
      return res;
    } catch (e) {
      LogService.instance.error('Update', 'silent version check failed', e);
      return null;
    }
  }

  /// 手动检查：不支持的平台返回 null；网络/服务端异常向上抛。
  Future<VersionCheckResult?> checkManually() async {
    final channel = _channel;
    if (channel == null) return null;
    return _api.check(channel: channel, versionCode: await _buildNumber());
  }
}
