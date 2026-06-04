import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:today_wear/l10n/app_localizations.dart';

import '../services/purchase_service.dart';
import '../theme/app_theme_tokens.dart';
import '../widgets/app_toast.dart';

/// 自实现付费墙（不用 RevenueCat Paywall 模板）
///
/// 商品数据来自 RevenueCat offering（月订/年订/买断），购买经
/// [PurchaseService.purchase] 走 RC 收银，成功后由服务端核实点亮并
/// `Navigator.pop(true)`。
class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  final _purchase = PurchaseService.instance;

  List<Package>? _packages;
  bool _loadFailed = false;
  Package? _selected;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _packages = null;
      _loadFailed = false;
    });
    try {
      final packages = await _purchase.loadPackages();
      if (!mounted) return;
      setState(() {
        _packages = packages;
        // 默认选中年订（无年订则第一个）
        _selected = packages
                .where((p) => p.packageType == PackageType.annual)
                .firstOrNull ??
            packages.firstOrNull;
      });
    } catch (e) {
      debugPrint('PaywallPage load error: $e');
      if (mounted) setState(() => _loadFailed = true);
    }
  }

  Future<void> _buy() async {
    final package = _selected;
    if (package == null || _busy) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    final outcome = await _purchase.purchase(package);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (outcome) {
      case PaywallOutcome.purchased:
        AppToast.success(l10n.proPurchaseSuccess);
        Navigator.of(context).pop(true);
      case PaywallOutcome.alreadyPro:
        AppToast.success(l10n.proAlreadyActive);
        Navigator.of(context).pop(true);
      case PaywallOutcome.paymentPending:
        AppToast.warning(l10n.proPaymentPending);
      case PaywallOutcome.cancelled:
        break;
      case PaywallOutcome.notLoggedIn:
        AppToast.warning(l10n.proLoginFirst);
      case PaywallOutcome.unsupported:
        AppToast.warning(l10n.proUnsupportedPlatform);
      default:
        AppToast.error(l10n.proPurchaseFailed);
    }
  }

  Future<void> _restore() async {
    if (_busy) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    final outcome = await _purchase.restorePurchases();
    if (!mounted) return;
    setState(() => _busy = false);
    switch (outcome) {
      case PaywallOutcome.restored:
        AppToast.success(l10n.proRestoreSuccess);
        Navigator.of(context).pop(true);
      case PaywallOutcome.nothingToRestore:
        AppToast.warning(l10n.proNothingToRestore);
      default:
        AppToast.error(l10n.proPurchaseFailed);
    }
  }

  String _packageLabel(AppLocalizations l10n, Package p) {
    return switch (p.packageType) {
      PackageType.monthly => l10n.proMonthlyLabel,
      PackageType.annual => l10n.proYearlyLabel,
      PackageType.lifetime => l10n.proLifetimeLabel,
      _ => p.storeProduct.title,
    };
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: tt.page,
      appBar: AppBar(
        backgroundColor: tt.page,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(l10n.proTitle,
            style: TextStyle(color: tt.ink, fontWeight: FontWeight.w800, fontSize: 18)),
        iconTheme: IconThemeData(color: tt.ink),
      ),
      body: SafeArea(child: _buildBody(tt, l10n)),
    );
  }

  Widget _buildBody(AppThemeTokens tt, AppLocalizations l10n) {
    if (_loadFailed) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.proPaywallLoadFailed, style: TextStyle(color: tt.muted)),
            const SizedBox(height: 12),
            TextButton(onPressed: _load, child: Text(l10n.retry)),
          ],
        ),
      );
    }
    final packages = _packages;
    if (packages == null) {
      return Center(child: CircularProgressIndicator(color: tt.muted));
    }
    if (packages.isEmpty) {
      return Center(child: Text(l10n.proPaywallLoadFailed, style: TextStyle(color: tt.muted)));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Icon(Icons.workspace_premium_outlined, size: 44, color: tt.accent),
        const SizedBox(height: 12),
        Text(l10n.proIntro,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: tt.ink, height: 1.5)),
        const SizedBox(height: 24),
        for (final p in packages) ...[
          _packageCard(tt, l10n, p),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 14),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: (_busy || _selected == null) ? null : _buy,
            style: ElevatedButton.styleFrom(
              backgroundColor: tt.ink,
              foregroundColor: tt.page,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: _busy
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.4, color: tt.page),
                  )
                : Text(l10n.proPurchaseCta,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: _busy ? null : _restore,
            child: Text(l10n.proRestoreBtn,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tt.muted)),
          ),
        ),
        const SizedBox(height: 8),
        Text(l10n.proSubscriptionNote,
            style: TextStyle(fontSize: 11, color: tt.muted, height: 1.5)),
      ],
    );
  }

  Widget _packageCard(AppThemeTokens tt, AppLocalizations l10n, Package p) {
    final selected = identical(p, _selected);
    return GestureDetector(
      onTap: _busy ? null : () => setState(() => _selected = p),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: tt.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? tt.ink : tt.line,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: selected ? tt.ink : tt.muted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(_packageLabel(l10n, p),
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700, color: tt.ink)),
            ),
            Text(p.storeProduct.priceString,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w800, color: tt.ink)),
          ],
        ),
      ),
    );
  }
}
