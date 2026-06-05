import 'api_client.dart';

/// 远端账号 + 资料（GET /users/me）
class RemoteProfile {
  final int id;
  final String email;
  final String? nickname;
  final int? avatarImageId;
  final String? birthday; // YYYY-MM-DD
  final String? gender; // male/female/none
  final String? personality;
  final bool isPremium;
  final int? premiumExpiresAt; // Unix 秒
  final String? avatarUrl; // 仅 GFS 已配置且有头像时存在

  const RemoteProfile({
    required this.id,
    required this.email,
    this.nickname,
    this.avatarImageId,
    this.birthday,
    this.gender,
    this.personality,
    required this.isPremium,
    this.premiumExpiresAt,
    this.avatarUrl,
  });

  factory RemoteProfile.fromJson(Map<String, dynamic> j) => RemoteProfile(
        id: (j['id'] as num?)?.toInt() ?? 0,
        email: (j['email'] as String?) ?? '',
        nickname: j['nickname'] as String?,
        avatarImageId: (j['avatar_image_id'] as num?)?.toInt(),
        birthday: j['birthday'] as String?,
        gender: j['gender'] as String?,
        personality: j['personality'] as String?,
        isPremium: (j['is_premium'] as bool?) ?? false,
        premiumExpiresAt: (j['premium_expires_at'] as num?)?.toInt(),
        avatarUrl: j['avatar_url'] as String?,
      );
}

/// 远端登录会话（设备）
class RemoteSession {
  final String sessionId;
  final String deviceName;
  final String platform;
  final String appVersion;
  final String ip;
  final String lastActiveAt;
  final bool current;

  const RemoteSession({
    required this.sessionId,
    required this.deviceName,
    required this.platform,
    required this.appVersion,
    required this.ip,
    required this.lastActiveAt,
    required this.current,
  });

  factory RemoteSession.fromJson(Map<String, dynamic> j) => RemoteSession(
        sessionId: (j['session_id'] as String?) ?? '',
        deviceName: (j['device_name'] as String?) ?? '',
        platform: (j['platform'] as String?) ?? '',
        appVersion: (j['app_version'] as String?) ?? '',
        ip: (j['ip'] as String?) ?? '',
        lastActiveAt: (j['last_active_at'] as String?) ?? '',
        current: (j['current'] as bool?) ?? false,
      );
}

/// 用户 API（需登录）
class UserApi {
  final ApiClient _client;
  UserApi([ApiClient? client]) : _client = client ?? ApiClient.instance;

  Future<RemoteProfile> getMe() async {
    final data = await _client.get('/users/me');
    return RemoteProfile.fromJson((data as Map).cast<String, dynamic>());
  }

  /// 整体替换资料（传 null 清空对应字段）
  Future<RemoteProfile> updateProfile({
    String? nickname,
    String? birthday,
    String? gender,
    String? personality,
    int? avatarImageId,
  }) async {
    final data = await _client.put('/users/me/profile', body: {
      'nickname': nickname,
      'birthday': birthday,
      'gender': gender,
      'personality': personality,
      'avatar_image_id': avatarImageId,
    });
    return RemoteProfile.fromJson((data as Map).cast<String, dynamic>());
  }

  Future<List<RemoteSession>> listSessions() async {
    final data = await _client.get('/users/me/sessions');
    return ((data as List?) ?? const [])
        .map((e) => RemoteSession.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<void> deleteSession(String sessionId) =>
      _client.delete('/users/me/sessions/$sessionId');

  /// 修改语言偏好（服务端即时刷新所有在线会话）
  Future<void> updateLanguage(String language) =>
      _client.put('/users/me/language', body: {'language': language});

  /// 永久删除账号（服务端单事务清数据并吊销全部会话）。
  /// 密码错误抛 UnauthorizedException(code: invalid_credentials)。
  Future<void> deleteAccount(String password) =>
      _client.delete('/users/me', body: {'password': password});
}
