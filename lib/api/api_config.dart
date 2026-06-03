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
}
