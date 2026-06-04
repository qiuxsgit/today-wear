import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';

import '../services/profile_sync.dart';
import '../services/purchase_service.dart';
import '../services/session_service.dart';
import '../services/sync_service.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_tokens.dart';
import '../widgets/app_toast.dart';
import '../widgets/pro_status_card.dart';
import 'auth_page.dart';
import 'device_sessions_page.dart';

/// 账户与云同步页
///
/// 未登录：介绍 + 登录/注册入口；已登录：账号信息、同步状态与操作、设备管理、退出。
class AccountSyncPage extends StatefulWidget {
  const AccountSyncPage({super.key});

  @override
  State<AccountSyncPage> createState() => _AccountSyncPageState();
}

class _AccountSyncPageState extends State<AccountSyncPage> {
  final _session = SessionService.instance;
  final _sync = SyncService.instance;

  @override
  void initState() {
    super.initState();
    _session.addListener(_onChanged);
    _sync.addListener(_onChanged);
    _sync.loadMeta();
    // 进入页面时按服务端真相刷新 Pro 状态（未登录内部直接跳过）
    PurchaseService.instance.refreshServerStatus();
  }

  @override
  void dispose() {
    _session.removeListener(_onChanged);
    _sync.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _openAuth({bool register = false}) async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AuthPage(startWithRegister: register)),
    );
    if (ok == true) {
      // 登录后：调和资料 + 触发全量同步
      ProfileSync.instance.reconcileOnLogin().catchError((e) {
        debugPrint('Profile reconcile failed: $e');
      });
      _sync.syncInBackground();
    }
  }

  Future<void> _logout() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.accountLogout),
        content: Text(l10n.accountLogoutDialogContent),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.accountLogoutConfirm)),
        ],
      ),
    );
    if (confirmed != true) return;
    await _session.logout();
    if (mounted) AppToast.success(l10n.accountLoggedOutToast);
  }

  String _syncErrorText(AppLocalizations l10n) {
    switch (_sync.lastError) {
      case SyncError.premiumRequired:
        return l10n.syncErrPremiumRequired;
      case SyncError.network:
        return l10n.errNetwork;
      case SyncError.server:
        return _sync.lastErrorMessage ?? l10n.syncErrGeneric;
      case SyncError.unknown:
      case null:
        return l10n.syncErrGeneric;
    }
  }

  String _syncStatusText(AppLocalizations l10n) {
    switch (_sync.status) {
      case SyncStatus.syncing:
        return l10n.syncStatusSyncing;
      case SyncStatus.error:
        return _syncErrorText(l10n);
      case SyncStatus.idle:
        if (_sync.lastSyncedMs == 0) return l10n.syncStatusNever;
        final t = DateTime.fromMillisecondsSinceEpoch(_sync.lastSyncedMs);
        return l10n.syncStatusLast('${t.month}/${t.day} '
            '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}');
    }
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
        title: Text(l10n.accountSyncTitle,
            style: TextStyle(color: tt.ink, fontWeight: FontWeight.w800, fontSize: 18)),
        iconTheme: IconThemeData(color: tt.ink),
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: 72 + MediaQuery.of(context).padding.bottom,
        ),
        children:
            _session.isLoggedIn ? _loggedInChildren(tt, l10n) : _loggedOutChildren(tt, l10n),
      ),
    );
  }

  List<Widget> _loggedOutChildren(AppThemeTokens tt, AppLocalizations l10n) {
    return [
      _card(tt, [
        Icon(Icons.cloud_outlined, size: 44, color: tt.muted),
        const SizedBox(height: 12),
        Text(l10n.accountCloudOff,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: tt.ink)),
        const SizedBox(height: 8),
        Text(
          l10n.accountCloudIntro,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: tt.muted, height: 1.5),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => _openAuth(),
            style: ElevatedButton.styleFrom(
              backgroundColor: tt.ink,
              foregroundColor: tt.page,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(l10n.authLoginTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () => _openAuth(register: true),
            style: OutlinedButton.styleFrom(
              foregroundColor: tt.ink,
              side: BorderSide(color: tt.line),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(l10n.accountRegisterNewBtn,
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
      const SizedBox(height: AppSpacing.lg),
      const ProStatusCard(),
    ];
  }

  List<Widget> _loggedInChildren(AppThemeTokens tt, AppLocalizations l10n) {
    return [
      // 账号卡
      _card(tt, [
        Row(
          children: [
            Icon(Icons.account_circle_outlined, size: 34, color: tt.ink),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_session.email ?? '',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: tt.ink)),
                  const SizedBox(height: 2),
                  Text(l10n.accountLoggedIn, style: TextStyle(fontSize: 12, color: tt.muted)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Divider(height: 1, color: tt.line),
        _navRow(tt, l10n.accountDeviceManagement, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DeviceSessionsPage()));
        }),
        Divider(height: 1, color: tt.line),
        _navRow(tt, l10n.accountLogout, _logout, danger: true),
      ], crossAxisAlignment: CrossAxisAlignment.start),
      const SizedBox(height: AppSpacing.lg),
      // Pro 卡
      const ProStatusCard(),
      const SizedBox(height: AppSpacing.lg),
      // 同步卡
      _card(tt, [
        Row(
          children: [
            Expanded(
              child: Text(l10n.accountCloudSyncLabel,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: tt.ink)),
            ),
            Switch(
              value: _session.syncEnabled,
              activeThumbColor: tt.ink,
              onChanged: (v) => _session.setSyncEnabled(v),
            ),
          ],
        ),
        Divider(height: 1, color: tt.line),
        const SizedBox(height: 12),
        Row(
          children: [
            if (_sync.isSyncing)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: tt.muted),
              )
            else
              Icon(
                _sync.status == SyncStatus.error ? Icons.error_outline : Icons.check_circle_outline,
                size: 16,
                color: _sync.status == SyncStatus.error ? Colors.redAccent : tt.muted,
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(_syncStatusText(l10n), style: TextStyle(fontSize: 13, color: tt.muted)),
            ),
          ],
        ),
        // 同步被会员门控挡下时，就地给出开通入口（支付通道关闭时隐藏）
        if (_sync.status == SyncStatus.error &&
            _sync.lastError == SyncError.premiumRequired &&
            PurchaseService.instance.isConfigured) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () => presentProPaywallFlow(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: tt.ink,
                side: BorderSide(color: tt.line),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(l10n.proSubscribeBtn,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            onPressed: (!_session.syncEnabled || _sync.isSyncing)
                ? null
                : () => _sync.syncNow(),
            style: ElevatedButton.styleFrom(
              backgroundColor: tt.ink,
              foregroundColor: tt.page,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(_sync.isSyncing ? l10n.syncStatusSyncing : l10n.syncNowBtn,
                style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
        ),
      ], crossAxisAlignment: CrossAxisAlignment.start),
    ];
  }

  Widget _card(AppThemeTokens tt, List<Widget> children,
      {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center}) {
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
      child: Column(crossAxisAlignment: crossAxisAlignment, children: children),
    );
  }

  Widget _navRow(AppThemeTokens tt, String label, VoidCallback onTap, {bool danger = false}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: danger ? Colors.redAccent : tt.ink,
                  )),
            ),
            Icon(Icons.chevron_right, color: tt.muted, size: 18),
          ],
        ),
      ),
    );
  }
}
