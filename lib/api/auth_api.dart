import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

import '../services/locale_service.dart';
import 'api_client.dart';

/// 登录/注册返回的会话结果
class AuthResult {
  final int userId;
  final String email;
  final String sessionId;
  final int idleTtlSeconds;

  const AuthResult({
    required this.userId,
    required this.email,
    required this.sessionId,
    required this.idleTtlSeconds,
  });

  factory AuthResult.fromData(Map<String, dynamic> data) {
    final user = (data['user'] as Map?)?.cast<String, dynamic>() ?? const {};
    return AuthResult(
      userId: (user['id'] as num?)?.toInt() ?? 0,
      email: (user['email'] as String?) ?? '',
      sessionId: (data['session_id'] as String?) ?? '',
      idleTtlSeconds: (data['idle_ttl'] as num?)?.toInt() ?? 0,
    );
  }
}

/// 认证 API：注册 / 登录 / 注销 / 改密
class AuthApi {
  final ApiClient _client;
  AuthApi([ApiClient? client]) : _client = client ?? ApiClient.instance;

  Future<Map<String, dynamic>> _device() async {
    String appVersion = '';
    try {
      final info = await PackageInfo.fromPlatform();
      appVersion = info.version;
    } catch (_) {}
    String platform = 'unknown';
    try {
      platform = Platform.operatingSystem; // ios / android / macos ...
    } catch (_) {}
    return {
      'device_name': platform,
      'platform': platform,
      'app_version': appVersion,
    };
  }

  Future<AuthResult> register(String email, String password) async {
    final data = await _client.post('/auth/register', body: {
      'email': email,
      'password': password,
      'language': LocaleService.apiLanguageTag, // 持久化为用户语言偏好
      'device': await _device(),
    });
    return AuthResult.fromData((data as Map).cast<String, dynamic>());
  }

  Future<AuthResult> login(String email, String password) async {
    final data = await _client.post('/auth/login', body: {
      'email': email,
      'password': password,
      'language': LocaleService.apiLanguageTag, // 覆盖并持久化用户语言偏好
      'device': await _device(),
    });
    return AuthResult.fromData((data as Map).cast<String, dynamic>());
  }

  Future<void> logout() => _client.post('/auth/logout');

  Future<void> logoutAll() => _client.post('/auth/logout-all');

  Future<void> changePassword(String oldPassword, String newPassword) =>
      _client.post('/auth/change-password', body: {
        'old_password': oldPassword,
        'new_password': newPassword,
      });
}
