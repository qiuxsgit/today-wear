import 'api_client.dart';

/// 会员状态（服务端真相源，由 RevenueCat 核实后落库）
class PremiumStatus {
  final bool isPremium;

  /// Unix 秒；无会员历史为 null，买断（lifetime）为远期 9999-12-31
  final int? premiumExpiresAt;

  const PremiumStatus({required this.isPremium, this.premiumExpiresAt});

  factory PremiumStatus.fromJson(Map<String, dynamic> j) => PremiumStatus(
        isPremium: (j['is_premium'] as bool?) ?? false,
        premiumExpiresAt: (j['premium_expires_at'] as num?)?.toInt(),
      );
}

/// 购买 API（需登录）
///
/// 购买/恢复成功后调用，让服务端向 RevenueCat REST API 核实订阅并刷新
/// `is_premium`，做到秒级点亮、不等 Webhook。
class PurchaseApi {
  Future<PremiumStatus> refresh() async {
    final data = await ApiClient.instance.post('/purchases/refresh');
    return PremiumStatus.fromJson(data as Map<String, dynamic>);
  }
}
