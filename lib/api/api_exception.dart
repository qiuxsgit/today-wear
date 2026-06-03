/// API 异常体系
///
/// 服务端响应信封为 `{ "data": ..., "error": { "code", "message" } }`。
/// 非 2xx 时按状态码抛出对应子类，调用方可分别处理。
class ApiException implements Exception {
  /// HTTP 状态码（网络层错误为 0）
  final int status;

  /// 机器可读错误码（如 invalid_request / unauthorized）
  final String code;

  /// 人类可读错误信息
  final String message;

  const ApiException({
    required this.status,
    required this.code,
    required this.message,
  });

  @override
  String toString() => 'ApiException($status, $code): $message';
}

/// 401：会话缺失或失效
class UnauthorizedException extends ApiException {
  const UnauthorizedException({super.code = 'unauthorized', super.message = '登录已失效，请重新登录'})
      : super(status: 401);
}

/// 402：需要会员订阅
class PremiumRequiredException extends ApiException {
  const PremiumRequiredException({super.code = 'premium_required', super.message = '此功能需要会员'})
      : super(status: 402);
}

/// 409：唯一约束冲突（如邮箱已注册、标签重名）
class ConflictException extends ApiException {
  const ConflictException({required super.code, required super.message})
      : super(status: 409);
}

/// 网络层错误（无法连接、超时、响应非法）
class NetworkException extends ApiException {
  const NetworkException({super.message = '网络连接失败，请检查网络后重试'})
      : super(status: 0, code: 'network_error');
}
