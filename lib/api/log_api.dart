import 'api_client.dart';
import 'media_api.dart';

/// 客户端日志 API（需登录、不要求订阅 + 服务端已配置 GFS）
///
/// 上传流程：[uploadToken] 取直传策略 → GfsUploader 直传拿 file_id →
/// [report] 上报归属与设备信息落库。契约见 today-wear-server/docs/api.md → Logs。
class LogApi {
  final ApiClient _client;
  LogApi([ApiClient? client]) : _client = client ?? ApiClient.instance;

  /// 签发日志文件 GFS 直传策略
  /// （保存为 `<user_id>/log/<邮箱>_<logDate>_<HHmmss>.log.gz`）
  Future<UploadPolicy> uploadToken({required String logDate}) async {
    final data =
        await _client.post('/logs/upload-token', body: {'log_date': logDate});
    return UploadPolicy.fromJson((data as Map).cast<String, dynamic>());
  }

  /// 直传成功后上报日志文件元数据，返回服务端记录 id
  Future<int> report({
    required int fileId,
    required String logDate,
    required int fileSize,
    required String platform,
    required String platformVersion,
    required String deviceModel,
    required String appVersion,
    required String locale,
    required String timezone,
    required String remark,
  }) async {
    final data = await _client.post('/logs', body: {
      'file_id': fileId,
      'log_date': logDate,
      'file_size': fileSize,
      'platform': platform,
      'platform_version': platformVersion,
      'device_model': deviceModel,
      'app_version': appVersion,
      'locale': locale,
      'timezone': timezone,
      'remark': remark,
    });
    return ((data as Map)['id'] as num).toInt();
  }
}
