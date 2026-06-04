import 'api_client.dart';

/// GFS 直传策略（来自 POST /media/upload-token 的 policyData）
class UploadPolicy {
  final String gfsHost;
  final String appId;
  final String policy;
  final String signature;
  final int timestamp;
  final int expire;
  final String nonce;

  const UploadPolicy({
    required this.gfsHost,
    required this.appId,
    required this.policy,
    required this.signature,
    required this.timestamp,
    required this.expire,
    required this.nonce,
  });

  factory UploadPolicy.fromJson(Map<String, dynamic> j) {
    final pd = (j['policyData'] as Map?)?.cast<String, dynamic>() ?? const {};
    return UploadPolicy(
      gfsHost: (j['gfsHost'] as String?) ?? '',
      appId: (pd['appId'] as String?) ?? '',
      policy: (pd['policy'] as String?) ?? '',
      signature: (pd['signature'] as String?) ?? '',
      timestamp: (pd['timestamp'] as num?)?.toInt() ?? 0,
      expire: (pd['expire'] as num?)?.toInt() ?? 0,
      nonce: (pd['nonce'] as String?) ?? '',
    );
  }
}

/// 媒体 API（需会员 + 服务端已配置 GFS）
class MediaApi {
  final ApiClient _client;
  MediaApi([ApiClient? client]) : _client = client ?? ApiClient.instance;

  /// usage ∈ {avatar, outfit}，缺省 outfit
  Future<UploadPolicy> uploadToken({String usage = 'outfit'}) async {
    final data = await _client.post('/media/upload-token', body: {'usage': usage});
    return UploadPolicy.fromJson((data as Map).cast<String, dynamic>());
  }

  /// 按图片 id 批量换取签名读 URL（懒加载下载用，单次最多 100 个）。
  /// 返回 serverImageId → URL 映射；未出现在结果中的 id 视为不可用。
  Future<Map<int, String>> imageUrls(List<int> ids) async {
    final data = await _client.get(
      '/media/image-urls',
      query: {'ids': ids.join(',')},
    );
    final urls =
        ((data as Map)['urls'] as Map?)?.cast<String, dynamic>() ?? const {};
    return {
      for (final e in urls.entries)
        if (int.tryParse(e.key) != null && e.value is String)
          int.parse(e.key): e.value as String,
    };
  }
}
