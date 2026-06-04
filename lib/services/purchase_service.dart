import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/purchase_api.dart';
import '../api/user_api.dart';
import 'session_service.dart';

/// 购买 / 恢复购买的结果（UI 层映射 l10n 文案）
enum PaywallOutcome {
  purchased,
  restored,
  alreadyPro,
  cancelled,
  paymentPending,
  nothingToRestore,
  failed,
  unsupported,
  notLoggedIn,
}

/// 订阅/会员服务
///
/// 单例 ChangeNotifier。RevenueCat 负责收银（商品/收据），**付费墙 UI 全部
/// 自实现**（见 PaywallPage，不用 RevenueCat Paywall 模板）；**服务端是会员
/// 真相源**：功能门控只认 [isPro]（来自 `/users/me` / `POST /purchases/refresh`
/// 的 `is_premium`），本地 RC 权益 [rcEntitled] 仅作展示提示，防 hook 破解。
/// 购买必须先登录：appUserID 恒等于服务端 userId。
class PurchaseService extends ChangeNotifier {
  PurchaseService._();
  static final PurchaseService instance = PurchaseService._();

  /// RevenueCat entitlement 标识（Dashboard 上「今天穿什么 Pro」的 API identifier）
  static const String entitlementId = 'today_wear_pro';

  /// 客户端 SDK public key；上线时 --dart-define 覆盖为 appl_/goog_ key
  static const String _apiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: 'test_ccCdYLlFFZegNJyTXKMetukOEFr',
  );

  final PurchaseApi _purchaseApi = PurchaseApi();
  final UserApi _userApi = UserApi();

  bool _configured = false;
  bool _rcEntitled = false;
  bool _isPremium = false;
  int? _premiumExpiresAt;
  int? _boundUserId;
  bool _syncPending = false;

  /// 当前平台是否支持内购（macOS 仅作调试，不支持）
  bool get isSupported => !kIsWeb && (Platform.isIOS || Platform.isAndroid);

  /// SDK 是否初始化成功（失败时入口降级隐藏）
  bool get isConfigured => _configured;

  /// RC 本地权益（仅展示提示，不做功能门控）
  bool get rcEntitled => _rcEntitled;

  /// 服务端确认的会员状态（真相源）
  bool get isPro => _isPremium;

  /// 会员到期时间（Unix 秒）；买断为远期 9999-12-31
  int? get premiumExpiresAt => _premiumExpiresAt;

  /// 已购买但服务端尚未点亮（refresh 失败），UI 显示「正在生效」+ 重试
  bool get syncPending => _syncPending;

  /// Test Store key（`test_`）在 release 构建中会被 RevenueCat 原生层直接
  /// fatal（防带上线），且崩在原生层无法 catch。release + 测试 key 时跳过
  /// 配置 = 临时关闭支付通道（真机日常测试场景）；正式 key 经
  /// `--dart-define=REVENUECAT_API_KEY=appl_/goog_` 注入后自动启用。
  bool get _keyUsableInThisBuild =>
      _apiKey.isNotEmpty && !(kReleaseMode && _apiKey.startsWith('test_'));

  /// 启动时初始化 SDK 并绑定会话。失败只降级、不影响 App 其它功能。
  Future<void> init() async {
    if (!isSupported || !_keyUsableInThisBuild) return;
    try {
      final session = SessionService.instance;
      final config = PurchasesConfiguration(_apiKey);
      if (session.isLoggedIn && session.userId != null) {
        config.appUserID = session.userId.toString();
        _boundUserId = session.userId;
      }
      await Purchases.configure(config);
      _configured = true;
      Purchases.addCustomerInfoUpdateListener(_onCustomerInfo);
      session.addListener(_onSessionChanged);
      await refreshServerStatus();
    } catch (e) {
      debugPrint('PurchaseService init error: $e');
    }
  }

  /// 从服务端拉取会员状态（登录后 / 打开账户页时调用）
  Future<void> refreshServerStatus() async {
    if (!SessionService.instance.isLoggedIn) return;
    try {
      final profile = await _userApi.getMe();
      _isPremium = profile.isPremium;
      _premiumExpiresAt = profile.premiumExpiresAt;
      notifyListeners();
    } catch (e) {
      debugPrint('PurchaseService refreshServerStatus error: $e');
    }
  }

  /// 拉取当前 offering 的可购 package（自实现付费墙的数据源）。
  /// 按 月订 → 年订 → 买断 排序；失败抛异常由页面展示重试。
  Future<List<Package>> loadPackages() async {
    final offerings = await Purchases.getOfferings();
    final packages = List<Package>.of(
      offerings.current?.availablePackages ?? const <Package>[],
    );
    int rank(PackageType t) => switch (t) {
          PackageType.monthly => 0,
          PackageType.annual => 1,
          PackageType.lifetime => 2,
          _ => 3,
        };
    packages.sort((a, b) => rank(a.packageType).compareTo(rank(b.packageType)));
    return packages;
  }

  /// 购买指定 package（需登录；成功后让服务端核实点亮）
  Future<PaywallOutcome> purchase(Package package) async {
    if (!isSupported || !_configured) return PaywallOutcome.unsupported;
    if (!SessionService.instance.isLoggedIn) return PaywallOutcome.notLoggedIn;
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      _onCustomerInfo(result.customerInfo);
      await _syncWithServer();
      return PaywallOutcome.purchased;
    } on PlatformException catch (e) {
      switch (PurchasesErrorHelper.getErrorCode(e)) {
        case PurchasesErrorCode.purchaseCancelledError:
          return PaywallOutcome.cancelled;
        case PurchasesErrorCode.paymentPendingError:
          return PaywallOutcome.paymentPending;
        case PurchasesErrorCode.productAlreadyPurchasedError:
          await _syncWithServer();
          return PaywallOutcome.alreadyPro;
        default:
          debugPrint('PurchaseService purchase error: $e');
          return PaywallOutcome.failed;
      }
    } catch (e) {
      debugPrint('PurchaseService purchase error: $e');
      return PaywallOutcome.failed;
    }
  }

  /// 恢复购买（换设备/重装后）
  Future<PaywallOutcome> restorePurchases() async {
    if (!isSupported || !_configured) return PaywallOutcome.unsupported;
    if (!SessionService.instance.isLoggedIn) return PaywallOutcome.notLoggedIn;
    try {
      final info = await Purchases.restorePurchases();
      _onCustomerInfo(info);
      if (!info.entitlements.active.containsKey(entitlementId)) {
        return PaywallOutcome.nothingToRestore;
      }
      await _syncWithServer();
      return PaywallOutcome.restored;
    } catch (e) {
      debugPrint('PurchaseService restorePurchases error: $e');
      return PaywallOutcome.failed;
    }
  }

  /// 打开系统订阅管理页（取消/改套餐在商店侧完成，结果经 Webhook 回流）
  Future<void> openManageSubscriptions() async {
    final url = Platform.isIOS
        ? 'https://apps.apple.com/account/subscriptions'
        : 'https://play.google.com/store/account/subscriptions';
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('PurchaseService openManageSubscriptions error: $e');
    }
  }

  /// 「正在生效」状态下的手动重试
  Future<bool> retrySync() async {
    await _syncWithServer();
    return !_syncPending;
  }

  /// 购买/恢复后让服务端向 RevenueCat 核实并点亮会员。
  /// 失败置 [syncPending]（RC 已扣款、服务端未点亮），Webhook 兜底自愈。
  Future<void> _syncWithServer() async {
    try {
      final status = await _purchaseApi.refresh();
      _isPremium = status.isPremium;
      _premiumExpiresAt = status.premiumExpiresAt;
      _syncPending = false;
      notifyListeners();
    } catch (e) {
      debugPrint('PurchaseService syncWithServer error: $e');
      _syncPending = true;
      notifyListeners();
    }
  }

  /// RC 权益变化（购买/续费/到期推送）→ 更新展示提示
  void _onCustomerInfo(CustomerInfo info) {
    final entitled = info.entitlements.active.containsKey(entitlementId);
    if (entitled == _rcEntitled) return;
    _rcEntitled = entitled;
    notifyListeners();
  }

  /// 会话变化：登录 → logIn 绑定 userId；退出 → logOut 回匿名并清本地状态
  void _onSessionChanged() {
    if (!_configured) return;
    final session = SessionService.instance;
    if (session.isLoggedIn && session.userId != null) {
      if (session.userId == _boundUserId) return;
      _boundUserId = session.userId;
      _bindUser(session.userId.toString());
    } else if (_boundUserId != null) {
      _boundUserId = null;
      _isPremium = false;
      _premiumExpiresAt = null;
      _syncPending = false;
      notifyListeners();
      _unbindUser();
    }
  }

  Future<void> _bindUser(String userId) async {
    try {
      final result = await Purchases.logIn(userId);
      _onCustomerInfo(result.customerInfo);
      await refreshServerStatus();
    } catch (e) {
      debugPrint('PurchaseService logIn error: $e');
    }
  }

  Future<void> _unbindUser() async {
    try {
      final info = await Purchases.logOut();
      _onCustomerInfo(info);
    } catch (e) {
      debugPrint('PurchaseService logOut error: $e');
    }
  }
}
