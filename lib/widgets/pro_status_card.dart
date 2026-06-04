import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';

import '../screens/auth_page.dart';
import '../screens/paywall_page.dart';
import '../services/purchase_service.dart';
import '../services/session_service.dart';
import '../theme/app_theme_tokens.dart';
import 'app_toast.dart';

/// 2100-01-01（Unix 秒）之后的到期时间视为买断（服务端用 9999-12-31 表示）
const int _lifetimeThresholdSec = 4102444800;

/// 走一遍「开通 Pro」流程：未登录先去登录页，再进自实现付费墙
/// [PaywallPage]。供 Pro 卡与 402 引导按钮复用。
Future<void> presentProPaywallFlow(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  if (!PurchaseService.instance.isSupported ||
      !PurchaseService.instance.isConfigured) {
    AppToast.warning(l10n.proUnsupportedPlatform);
    return;
  }
  if (!SessionService.instance.isLoggedIn) {
    AppToast.warning(l10n.proLoginFirst);
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AuthPage()),
    );
    if (ok != true || !context.mounted) return;
  }
  await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (_) => const PaywallPage()),
  );
}

void _toastOutcome(AppLocalizations l10n, PaywallOutcome outcome) {
  switch (outcome) {
    case PaywallOutcome.purchased:
      AppToast.success(l10n.proPurchaseSuccess);
    case PaywallOutcome.restored:
      AppToast.success(l10n.proRestoreSuccess);
    case PaywallOutcome.alreadyPro:
      AppToast.success(l10n.proAlreadyActive);
    case PaywallOutcome.paymentPending:
      AppToast.warning(l10n.proPaymentPending);
    case PaywallOutcome.nothingToRestore:
      AppToast.warning(l10n.proNothingToRestore);
    case PaywallOutcome.failed:
      AppToast.error(l10n.proPurchaseFailed);
    case PaywallOutcome.unsupported:
      AppToast.warning(l10n.proUnsupportedPlatform);
    case PaywallOutcome.notLoggedIn:
      AppToast.warning(l10n.proLoginFirst);
    case PaywallOutcome.cancelled:
      break; // 用户主动取消，静默
  }
}

/// 「今天穿什么 Pro」状态卡（账户与云同步页）
///
/// 未开通：介绍 + 开通 + 恢复购买；已开通：到期信息 + 管理订阅（Customer
/// Center）。Pro 状态以服务端为准（PurchaseService.isPro）。
class ProStatusCard extends StatefulWidget {
  const ProStatusCard({super.key});

  @override
  State<ProStatusCard> createState() => _ProStatusCardState();
}

class _ProStatusCardState extends State<ProStatusCard> {
  final _purchase = PurchaseService.instance;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _purchase.addListener(_onChanged);
  }

  @override
  void dispose() {
    _purchase.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore(AppLocalizations l10n) async {
    final outcome = await _purchase.restorePurchases();
    _toastOutcome(l10n, outcome);
  }

  Future<void> _retrySync(AppLocalizations l10n) async {
    final ok = await _purchase.retrySync();
    if (!ok) AppToast.error(l10n.errNetwork);
  }

  /// 买断（服务端用远期 9999-12-31 表示）→ 无可管理的订阅
  bool get _isLifetime {
    final sec = _purchase.premiumExpiresAt;
    return sec == null || sec >= _lifetimeThresholdSec;
  }

  String _expiryText(AppLocalizations l10n) {
    if (_isLifetime) return l10n.proLifetime;
    final d = DateTime.fromMillisecondsSinceEpoch(_purchase.premiumExpiresAt! * 1000);
    return l10n.proExpiresAt('${d.year}/${d.month}/${d.day}');
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    final l10n = AppLocalizations.of(context)!;
    // 初始化失败（手机上 SDK 不可用）→ 整卡隐藏，不影响其它功能
    if (_purchase.isSupported && !_purchase.isConfigured) {
      return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: tt.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x0F554230), blurRadius: 24, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.workspace_premium_outlined, size: 22, color: tt.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(l10n.proTitle,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: tt.ink)),
              ),
              if (_purchase.isPro)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: tt.mist,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(l10n.proActiveBadge,
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700, color: tt.ink)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (_purchase.isPro) ..._proChildren(tt, l10n) else ..._freeChildren(tt, l10n),
        ],
      ),
    );
  }

  List<Widget> _proChildren(AppThemeTokens tt, AppLocalizations l10n) {
    return [
      Text(_expiryText(l10n), style: TextStyle(fontSize: 13, color: tt.muted)),
      if (_purchase.isSupported && !_isLifetime) ...[
        const SizedBox(height: 8),
        Divider(height: 1, color: tt.line),
        GestureDetector(
          onTap: () => _run(() => _purchase.openManageSubscriptions()),
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: 44,
            child: Row(
              children: [
                Expanded(
                  child: Text(l10n.proManageBtn,
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700, color: tt.ink)),
                ),
                Icon(Icons.chevron_right, color: tt.muted, size: 18),
              ],
            ),
          ),
        ),
      ],
    ];
  }

  List<Widget> _freeChildren(AppThemeTokens tt, AppLocalizations l10n) {
    if (!_purchase.isSupported) {
      // macOS 调试平台：只展示说明
      return [
        Text(l10n.proIntro, style: TextStyle(fontSize: 13, color: tt.muted, height: 1.5)),
        const SizedBox(height: 6),
        Text(l10n.proUnsupportedPlatform,
            style: TextStyle(fontSize: 12, color: tt.muted)),
      ];
    }
    if (_purchase.syncPending) {
      // 已扣款、服务端未点亮：提示生效中 + 重试
      return [
        Text(l10n.proSyncPending, style: TextStyle(fontSize: 13, color: tt.muted)),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton(
            onPressed: _busy ? null : () => _run(() => _retrySync(l10n)),
            style: OutlinedButton.styleFrom(
              foregroundColor: tt.ink,
              side: BorderSide(color: tt.line),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(l10n.retry, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
      ];
    }
    return [
      Text(l10n.proIntro, style: TextStyle(fontSize: 13, color: tt.muted, height: 1.5)),
      const SizedBox(height: 14),
      SizedBox(
        width: double.infinity,
        height: 46,
        child: ElevatedButton(
          onPressed: _busy ? null : () => _run(() => presentProPaywallFlow(context)),
          style: ElevatedButton.styleFrom(
            backgroundColor: tt.ink,
            foregroundColor: tt.page,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: _busy
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.2, color: tt.page),
                )
              : Text(l10n.proSubscribeBtn,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
      ),
      const SizedBox(height: 4),
      Center(
        child: TextButton(
          onPressed: _busy ? null : () => _run(() => _restore(l10n)),
          child: Text(l10n.proRestoreBtn,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tt.muted)),
        ),
      ),
    ];
  }
}
