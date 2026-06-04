/// API 异常体系
///
/// 服务端响应信封为 `{ "data": ..., "error": { "code", "message" } }`。
/// 非 2xx 时按状态码抛出对应子类，调用方可分别处理。
///
/// 本层不携带任何硬编码提示文案：`message` 仅存放服务端返回的
/// （已按 Accept-Language 本地化的）信息，为空时由 UI 层按 [code]
/// 映射 l10n 文案（见 `lib/l10n/api_error_l10n.dart`）。
class ApiException implements Exception {
  /// HTTP 状态码（网络层错误为 0）
  final int status;

  /// 机器可读错误码（如 invalid_request / unauthorized）
  final String code;

  /// 服务端返回的人类可读错误信息（可能为空，UI 层需兜底）
  final String message;

  const ApiException({
    required this.status,
    required this.code,
    this.message = '',
  });

  @override
  String toString() => 'ApiException($status, $code): $message';
}

/// 401：会话缺失或失效
class UnauthorizedException extends ApiException {
  const UnauthorizedException({super.code = 'unauthorized', super.message})
      : super(status: 401);
}

/// 402：需要会员订阅
class PremiumRequiredException extends ApiException {
  const PremiumRequiredException({super.code = 'premium_required', super.message})
      : super(status: 402);
}

/// 409：唯一约束冲突（如邮箱已注册、标签重名）
class ConflictException extends ApiException {
  const ConflictException({required super.code, required super.message})
      : super(status: 409);
}

/// 网络层错误（无法连接、超时、响应非法）
class NetworkException extends ApiException {
  const NetworkException({super.code = 'network_error'}) : super(status: 0);
}
