import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_exception.dart';

/// 统一 HTTP 客户端
///
/// - 自动注入 `Authorization: Bearer <token>`（token 由 [tokenProvider] 提供）
/// - 解析 `{ data, error }` 信封，2xx 返回 `data`，否则按状态码抛 [ApiException]
/// - 401 时回调 [onUnauthorized]（用于清理本地会话）
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  final http.Client _http = http.Client();

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
    final h = <String, String>{};
    if (json) h['Content-Type'] = 'application/json';
    final token = tokenProvider?.call();
    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _send(() => _http.get(_uri(path, query), headers: _headers(json: false)));

  Future<dynamic> post(String path, {Object? body}) => _send(() => _http.post(
        _uri(path),
        headers: _headers(),
        body: body == null ? null : jsonEncode(body),
      ));

  Future<dynamic> put(String path, {Object? body}) => _send(() => _http.put(
        _uri(path),
        headers: _headers(),
        body: body == null ? null : jsonEncode(body),
      ));

  Future<dynamic> delete(String path) =>
      _send(() => _http.delete(_uri(path), headers: _headers(json: false)));

  /// 执行请求并解析信封，统一异常处理。
  Future<dynamic> _send(Future<http.Response> Function() run) async {
    http.Response res;
    try {
      res = await run().timeout(ApiConfig.timeout);
    } on TimeoutException {
      throw const NetworkException(message: '请求超时，请稍后重试');
    } on SocketException {
      throw const NetworkException();
    } on http.ClientException {
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
      return envelope?['data'];
    }

    // 错误：从信封提取 code/message，缺失则用兜底
    String code = 'error';
    String message = 'HTTP ${res.statusCode}';
    final err = envelope?['error'];
    if (err is Map<String, dynamic>) {
      code = (err['code'] as String?) ?? code;
      message = (err['message'] as String?) ?? message;
    } else if (err is String) {
      message = err;
    }

    switch (res.statusCode) {
      case 401:
        onUnauthorized?.call();
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
