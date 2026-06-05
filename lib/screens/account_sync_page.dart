import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';

import '../api/api_exception.dart';
import '../database/database.dart';
import '../l10n/api_error_l10n.dart';
import '../services/profile_sync.dart';
import '../services/purchase_service.dart';
import '../services/session_service.dart';
import '../services/sync_service.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_tokens.dart';
import '../widgets/account_logged_out_card.dart';
import '../widgets/app_toast.dart';
import '../widgets/delete_account_dialog.dart';
import '../widgets/sync_status_card.dart';
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

  Future<void> _deleteAccount() async {
    final l10n = AppLocalizations.of(context)!;
    final password = await DeleteAccountDialog.show(context);
    if (password == null || !mounted) return;
    if (password.isEmpty) {
      AppToast.warning(l10n.accountDeletePasswordRequired);
      return;
    }
    try {
      await SessionService.instance.deleteAccount(password);
      final db = AppDatabase();
      await db.outfitDao.resetSyncMetadata();
      await db.tagDao.resetSyncMetadata();
      await db.imageDao.resetServerImageIds();
      if (!mounted) return;
      AppToast.success(AppLocalizations.of(context)!.accountDeleteSuccess);
      setState(() {});
    } on ApiException catch (e) {
      if (!mounted) return;
      AppToast.warning(localizedApiError(AppLocalizations.of(context)!, e));
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
            _session.isLoggedIn ? _loggedInChildren(tt, l10n) : _loggedOutChildren(),
      ),
    );
  }

  List<Widget> _loggedOutChildren() {
    return [
      AccountLoggedOutCard(
        onLogin: () => _openAuth(),
        onRegister: () => _openAuth(register: true),
      ),
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
        Divider(height: 1, color: tt.line),
        _navRow(tt, l10n.accountDelete, _deleteAccount, danger: true),
      ], crossAxisAlignment: CrossAxisAlignment.start),
      const SizedBox(height: AppSpacing.lg),
      // Pro 卡 + 同步卡
      const SyncSection(),
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
