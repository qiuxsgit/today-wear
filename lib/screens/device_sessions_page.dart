import 'package:flutter/material.dart';

import '../api/api_exception.dart';
import '../api/user_api.dart';
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
  String? _error;

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
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = '加载失败，请稍后重试');
    }
  }

  Future<void> _kick(RemoteSession s) async {
    try {
      await _userApi.deleteSession(s.sessionId);
      AppToast.success('已移除该设备');
      await _load();
    } on ApiException catch (e) {
      AppToast.error(e.message);
    } catch (_) {
      AppToast.error('操作失败，请稍后重试');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    return Scaffold(
      backgroundColor: tt.page,
      appBar: AppBar(
        backgroundColor: tt.page,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('登录设备',
            style: TextStyle(color: tt.ink, fontWeight: FontWeight.w800, fontSize: 18)),
        iconTheme: IconThemeData(color: tt.ink),
      ),
      body: _buildBody(tt),
    );
  }

  Widget _buildBody(AppThemeTokens tt) {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: TextStyle(color: tt.muted)),
            const SizedBox(height: 12),
            TextButton(onPressed: _load, child: const Text('重试')),
          ],
        ),
      );
    }
    final sessions = _sessions;
    if (sessions == null) {
      return Center(child: CircularProgressIndicator(color: tt.muted));
    }
    if (sessions.isEmpty) {
      return Center(child: Text('暂无活跃会话', style: TextStyle(color: tt.muted)));
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
      itemBuilder: (context, i) => _sessionCard(tt, sessions[i]),
    );
  }

  Widget _sessionCard(AppThemeTokens tt, RemoteSession s) {
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
                        child: Text('本机',
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
              tooltip: '移除该设备',
              onPressed: () => _kick(s),
            ),
        ],
      ),
    );
  }
}
