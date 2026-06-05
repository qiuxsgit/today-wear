import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';
import '../api/auth_api.dart';
import 'log_service.dart';

/// 会话/账号状态服务
///
/// 单例 ChangeNotifier，持有不透明 SessionId 与用户摘要，持久化到
/// SharedPreferences。负责把 token 注入 [ApiClient]，并在 401 时清理本地会话。
/// 离线优先：未登录不影响 App 任何本地功能。
class SessionService extends ChangeNotifier {
  SessionService._();
  static final SessionService instance = SessionService._();

  static const String _kSessionId = 'session_id';
  static const String _kUserId = 'user_id';
  static const String _kEmail = 'user_email';
  static const String _kSyncEnabled = 'sync_enabled';

  final AuthApi _authApi = AuthApi();

  String? _sessionId;
  int? _userId;
  String? _email;
  bool _syncEnabled = true;

  bool get isLoggedIn => _sessionId != null && _sessionId!.isNotEmpty;
  int? get userId => _userId;
  String? get email => _email;

  /// 是否开启云同步（仅登录后有意义）
  bool get syncEnabled => _syncEnabled;

  /// 启动时恢复会话，并把 token 注入 ApiClient。
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _sessionId = prefs.getString(_kSessionId);
      _userId = prefs.getInt(_kUserId);
      _email = prefs.getString(_kEmail);
      _syncEnabled = prefs.getBool(_kSyncEnabled) ?? true;
    } catch (e) {
      debugPrint('SessionService init error: $e');
    }
    ApiClient.instance.tokenProvider = () => _sessionId;
    ApiClient.instance.onUnauthorized = _handleUnauthorized;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    final res = await _authApi.register(email, password);
    await _apply(res);
    LogService.instance.info('Session', 'register ok user_id=$_userId');
  }

  Future<void> login(String email, String password) async {
    final res = await _authApi.login(email, password);
    await _apply(res);
    LogService.instance.info('Session', 'login ok user_id=$_userId');
  }

  /// 退出当前设备登录（尽力通知服务端，失败也清本地）
  Future<void> logout() async {
    try {
      await _authApi.logout();
    } catch (_) {}
    await _clear();
    LogService.instance.info('Session', 'logout');
  }

  /// 退出全部设备
  Future<void> logoutAll() async {
    try {
      await _authApi.logoutAll();
    } catch (_) {}
    await _clear();
    LogService.instance.info('Session', 'logout all');
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _authApi.changePassword(oldPassword, newPassword);
    // 服务端改密会吊销所有会话 → 本地需重新登录
    await _clear();
  }

  Future<void> setSyncEnabled(bool enabled) async {
    _syncEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSyncEnabled, enabled);
    notifyListeners();
  }

  Future<void> _apply(AuthResult res) async {
    _sessionId = res.sessionId;
    _userId = res.userId;
    _email = res.email;
    _syncEnabled = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSessionId, _sessionId!);
    await prefs.setInt(_kUserId, _userId!);
    await prefs.setString(_kEmail, _email ?? '');
    await prefs.setBool(_kSyncEnabled, true);
    notifyListeners();
  }

  Future<void> _clear() async {
    _sessionId = null;
    _userId = null;
    _email = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSessionId);
    await prefs.remove(_kUserId);
    await prefs.remove(_kEmail);
    notifyListeners();
  }

  /// ApiClient 收到 401 时回调：token 失效，清本地会话（不发网络请求）。
  void _handleUnauthorized() {
    debugPrint('SessionService: session expired (401), clearing local session');
    LogService.instance.warn('Session', 'session expired (401), local session cleared');
    _sessionId = null;
    _userId = null;
    _email = null;
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove(_kSessionId);
      prefs.remove(_kUserId);
      prefs.remove(_kEmail);
    });
    notifyListeners();
  }
}
