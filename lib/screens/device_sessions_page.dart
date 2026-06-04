import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';

import '../api/api_exception.dart';
import '../api/user_api.dart';
import '../l10n/api_error_l10n.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_tokens.dart';
import '../widgets/app_toast.dart';

/// 登录设备管理页：列出活跃会话，可踢掉其它设备。
class DeviceSessionsPage extends StatefulWidget {
  const DeviceSessionsPage({super.key});

  @override
  State<DeviceSessionsPage> createState() => _DeviceSessionsPageState();
}

class _DeviceSessionsPageState extends State<DeviceSessionsPage> {
  final _userApi = UserApi();
  List<RemoteSession>? _sessions;

  /// 加载失败的异常，build 时映射 l10n 文案（initState 阶段拿不到 l10n）
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _sessions = null;
      _error = null;
    });
    try {
      final list = await _userApi.listSessions();
      if (mounted) setState(() => _sessions = list);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _kick(RemoteSession s) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await _userApi.deleteSession(s.sessionId);
      AppToast.success(l10n.deviceRemoved);
      await _load();
    } on ApiException catch (e) {
      AppToast.error(localizedApiError(l10n, e));
    } catch (_) {
      AppToast.error(l10n.errGeneric);
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
        title: Text(l10n.deviceSessionsTitle,
            style: TextStyle(color: tt.ink, fontWeight: FontWeight.w800, fontSize: 18)),
        iconTheme: IconThemeData(color: tt.ink),
      ),
      body: _buildBody(tt, l10n),
    );
  }

  Widget _buildBody(AppThemeTokens tt, AppLocalizations l10n) {
    final error = _error;
    if (error != null) {
      final text =
          error is ApiException ? localizedApiError(l10n, error) : l10n.errLoadFailed;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: TextStyle(color: tt.muted)),
            const SizedBox(height: 12),
            TextButton(onPressed: _load, child: Text(l10n.retry)),
          ],
        ),
      );
    }
    final sessions = _sessions;
    if (sessions == null) {
      return Center(child: CircularProgressIndicator(color: tt.muted));
    }
    if (sessions.isEmpty) {
      return Center(child: Text(l10n.deviceSessionsEmpty, style: TextStyle(color: tt.muted)));
    }
    return ListView.separated(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: 72 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: sessions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _sessionCard(tt, l10n, sessions[i]),
    );
  }

  Widget _sessionCard(AppThemeTokens tt, AppLocalizations l10n, RemoteSession s) {
    final subtitle = [
      if (s.appVersion.isNotEmpty) 'v${s.appVersion}',
      if (s.ip.isNotEmpty) s.ip,
      if (s.lastActiveAt.isNotEmpty) s.lastActiveAt.replaceFirst('T', ' ').split('.').first,
    ].join(' · ');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tt.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x0F554230), blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Icon(
            s.platform == 'ios' || s.platform == 'macos'
                ? Icons.phone_iphone
                : Icons.phone_android,
            color: tt.ink,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        s.deviceName.isNotEmpty ? s.deviceName : s.platform,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700, color: tt.ink),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (s.current) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: tt.mist,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(l10n.deviceCurrentBadge,
                            style: TextStyle(fontSize: 10, color: tt.ink)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: TextStyle(fontSize: 12, color: tt.muted),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (!s.current)
            IconButton(
              icon: Icon(Icons.logout, size: 20, color: tt.muted),
              tooltip: l10n.deviceRemoveTooltip,
              onPressed: () => _kick(s),
            ),
        ],
      ),
    );
  }
}
