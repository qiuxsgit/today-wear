/// API 环境配置
///
/// 默认指向测试环境。如需覆盖（如本地后端 / 生产），构建时传：
///   flutter run --dart-define=API_BASE_URL=https://your-host/api/v1
class ApiConfig {
  ApiConfig._();

  /// REST API 基地址（含 /api/v1 前缀，不带末尾斜杠）
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://today-wear-test.qiuxs.cn/api/v1',
  );

  /// 单次请求超时
  static const Duration timeout = Duration(seconds: 20);

  /// 服务端托管静态页 URL（隐私政策/用户协议等）。
  /// baseUrl 含 /api/v1 前缀，静态页挂在站点根，故取 origin 拼接。
  /// bg/fg 为 6 位 hex（不带 #）的主题色参数，服务端据此定制页面配色。
  static String staticPageUrl(String group, String key,
      {String? lang, String? bg, String? fg}) {
    final origin = Uri.parse(baseUrl).origin;
    final params = [
      if (lang != null) 'lang=$lang',
      if (bg != null) 'bg=$bg',
      if (fg != null) 'fg=$fg',
    ];
    final suffix = params.isEmpty ? '' : '?${params.join('&')}';
    return '$origin/static/$group/$key.html$suffix';
  }
}
