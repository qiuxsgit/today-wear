import 'dart:io';

import 'package:flutter/foundation.dart';

/// 分发渠道识别（构建时注入）
///
/// Android 打包必须显式传 --dart-define=DIST_CHANNEL=play|apk。
/// 忘传时兜底 play：后果只是非 Play 包跳了商店页；反之（Play 包做应用内
/// 下载安装）违反 Google Play 政策，故兜底方向不可反过来。
/// iOS 运行时即 appstore，无需传参；macOS 等平台不支持版本检查（返回 null）。
class DistChannel {
  DistChannel._();

  static const String channelPlay = 'play';
  static const String channelApk = 'apk';
  static const String channelAppStore = 'appstore';

  static const String _defined =
      String.fromEnvironment('DIST_CHANNEL', defaultValue: channelPlay);

  /// 当前渠道；不支持的平台返回 null（调用方应跳过检查/隐藏入口）。
  static String? resolve() {
    if (kIsWeb) return null;
    return resolveFor(_defined, isIOS: Platform.isIOS, isAndroid: Platform.isAndroid);
  }

  /// 纯映射逻辑，便于在宿主平台上单测。
  @visibleForTesting
  static String? resolveFor(String defined,
      {required bool isIOS, required bool isAndroid}) {
    if (isIOS) return channelAppStore;
    if (isAndroid) return defined == channelApk ? channelApk : channelPlay;
    return null;
  }
}
