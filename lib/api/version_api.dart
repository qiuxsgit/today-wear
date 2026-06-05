import 'api_client.dart';

/// 版本检查结果（GET /app/version/check）
class VersionCheckResult {
  final bool hasUpdate;
  final bool forceUpdate;
  final String latestVersionName;
  final int latestVersionCode;
  final String notes;

  /// 仅 apk 渠道返回（GFS 签名 URL，约 1 小时有效，过期重新 check）
  final String? downloadUrl;

  const VersionCheckResult({
    required this.hasUpdate,
    required this.forceUpdate,
    required this.latestVersionName,
    required this.latestVersionCode,
    required this.notes,
    this.downloadUrl,
  });

  factory VersionCheckResult.fromJson(Map<String, dynamic> j) => VersionCheckResult(
        hasUpdate: (j['hasUpdate'] as bool?) ?? false,
        forceUpdate: (j['forceUpdate'] as bool?) ?? false,
        latestVersionName: (j['latestVersionName'] as String?) ?? '',
        latestVersionCode: (j['latestVersionCode'] as num?)?.toInt() ?? 0,
        notes: (j['notes'] as String?) ?? '',
        downloadUrl: j['downloadUrl'] as String?,
      );
}

/// 版本检查 API（公开接口，无需登录；lang 由 ApiClient 的 Accept-Language 携带）
class VersionApi {
  final ApiClient _client;
  VersionApi([ApiClient? client]) : _client = client ?? ApiClient.instance;

  Future<VersionCheckResult> check({
    required String channel,
    required int versionCode,
  }) async {
    final data = await _client.get('/app/version/check', query: {
      'channel': channel,
      'version_code': versionCode,
    });
    return VersionCheckResult.fromJson((data as Map).cast<String, dynamic>());
  }
}
