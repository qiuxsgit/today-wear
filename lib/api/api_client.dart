import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../services/locale_service.dart';
import '../services/log_service.dart';
import 'api_config.dart';
import 'api_exception.dart';

/// 统一 HTTP 客户端
///
/// - 自动注入 `Authorization: Bearer <token>`（token 由 [tokenProvider] 提供）
/// - 解析 `{ data, error }` 信封，2xx 返回 `data`，否则按状态码抛 [ApiException]
/// - 401 时回调 [onUnauthorized]（用于清理本地会话）
class ApiClient {
  ApiClient._() : _http = http.Client();

  /// 测试用构造：注入自定义 [http.Client]（如 MockClient），不影响单例语义。
  @visibleForTesting
  ApiClient.forTesting(http.Client httpClient) : _http = httpClient;

  static final ApiClient instance = ApiClient._();

  final http.Client _http;

  /// 返回当前会话 token（未登录返回 null）。由 SessionService 注入。
  String? Function()? tokenProvider;

  /// 收到 401 时的回调。由 SessionService 注入。
  void Function()? onUnauthorized;

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final normalized = path.startsWith('/') ? path : '/$path';
    final base = Uri.parse('${ApiConfig.baseUrl}$normalized');
    if (query == null || query.isEmpty) return base;
    final qp = <String, String>{};
    query.forEach((k, v) {
      if (v != null) qp[k] = v.toString();
    });
    return qp.isEmpty ? base : base.replace(queryParameters: qp);
  }

  Map<String, String> _headers({bool json = true}) {
    final h = <String, String>{
      // 服务端按此本地化提示语（登录前/401 阶段的兜底语言来源）
      'Accept-Language': LocaleService.apiLanguageTag,
    };
    if (json) h['Content-Type'] = 'application/json';
    final token = tokenProvider?.call();
    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) => _send(
      'GET', path, () => _http.get(_uri(path, query), headers: _headers(json: false)));

  Future<dynamic> post(String path, {Object? body}) =>
      _send('POST', path, () => _http.post(
            _uri(path),
            headers: _headers(),
            body: body == null ? null : jsonEncode(body),
          ));

  Future<dynamic> put(String path, {Object? body}) =>
      _send('PUT', path, () => _http.put(
            _uri(path),
            headers: _headers(),
            body: body == null ? null : jsonEncode(body),
          ));

  Future<dynamic> delete(String path, {Object? body}) => _send(
        'DELETE',
        path,
        () => _http.delete(
          _uri(path),
          headers: _headers(json: body != null),
          body: body == null ? null : jsonEncode(body),
        ),
      );

  /// 执行请求并解析信封，统一异常处理。
  /// 每次请求记录 method + path + 状态码 + 耗时（不记录 header 与请求/响应体）。
  Future<dynamic> _send(
      String method, String path, Future<http.Response> Function() run) async {
    final watch = Stopwatch()..start();
    http.Response res;
    try {
      res = await run().timeout(ApiConfig.timeout);
    } on TimeoutException {
      LogService.instance
          .error('Api', '$method $path -> timeout (${watch.elapsedMilliseconds}ms)');
      throw const NetworkException(code: 'timeout');
    } on SocketException {
      LogService.instance
          .error('Api', '$method $path -> network error (${watch.elapsedMilliseconds}ms)');
      throw const NetworkException();
    } on http.ClientException {
      LogService.instance
          .error('Api', '$method $path -> network error (${watch.elapsedMilliseconds}ms)');
      throw const NetworkException();
    }

    // 204 / 空响应体
    if (res.statusCode == 204 || res.body.isEmpty) {
      if (res.statusCode >= 200 && res.statusCode < 300) return null;
    }

    Map<String, dynamic>? envelope;
    try {
      final decoded = jsonDecode(utf8.decode(res.bodyBytes));
      if (decoded is Map<String, dynamic>) envelope = decoded;
    } catch (_) {
      // 非 JSON 响应
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      LogService.instance.info('Api',
          '$method $path -> ${res.statusCode} (${watch.elapsedMilliseconds}ms)');
      return envelope?['data'];
    }

    // 错误：从信封提取 code/message；message 缺失时留空，由 UI 层按 code 映射 l10n
    String code = 'error';
    String message = '';
    final err = envelope?['error'];
    if (err is Map<String, dynamic>) {
      code = (err['code'] as String?) ?? code;
      message = (err['message'] as String?) ?? message;
    } else if (err is String) {
      message = err;
    }
    LogService.instance.error('Api',
        '$method $path -> ${res.statusCode} (${watch.elapsedMilliseconds}ms) code=$code');

    switch (res.statusCode) {
      case 401:
        // 401 仅在会话失效时清本地会话；invalid_credentials 是业务校验失败
        //（登录密码错 / 删除账号二次确认密码错），不得登出当前用户。
        if (code != 'invalid_credentials') {
          onUnauthorized?.call();
        }
        throw UnauthorizedException(code: code, message: message);
      case 402:
        throw PremiumRequiredException(code: code, message: message);
      case 409:
        throw ConflictException(code: code, message: message);
      default:
        if (kDebugMode) {
          debugPrint('[ApiClient] ${res.statusCode} $code: $message');
        }
        throw ApiException(status: res.statusCode, code: code, message: message);
    }
  }
}
