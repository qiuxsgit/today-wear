import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/purchase_service.dart';
import '../services/session_service.dart';
import '../services/sync_service.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_tokens.dart';
import 'pro_status_card.dart';
import 'sync_error_text.dart';

/// 云同步状态卡片（已登录时显示）
///
/// 展示同步开关、同步状态/错误文案、"立即同步"按钮。
/// 当因会员限制出错时，就地提供开通入口。
class SyncStatusCard extends StatelessWidget {
  const SyncStatusCard({super.key});

  String _syncStatusText(SyncService sync, AppLocalizations l10n) {
    switch (sync.status) {
      case SyncStatus.syncing:
        return l10n.syncStatusSyncing;
      case SyncStatus.error:
        return syncErrorText(sync.lastError, sync.lastErrorMessage, l10n);
      case SyncStatus.idle:
        if (sync.lastSyncedMs == 0) return l10n.syncStatusNever;
        final t = DateTime.fromMillisecondsSinceEpoch(sync.lastSyncedMs);
        return l10n.syncStatusLast('${t.month}/${t.day} '
            '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    final l10n = AppLocalizations.of(context)!;
    final session = SessionService.instance;
    final sync = SyncService.instance;

    return _card(tt, [
      Row(
        children: [
          Expanded(
            child: Text(l10n.accountCloudSyncLabel,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: tt.ink)),
          ),
          Switch(
            value: session.syncEnabled,
            activeThumbColor: tt.ink,
            onChanged: (v) => session.setSyncEnabled(v),
          ),
        ],
      ),
      Divider(height: 1, color: tt.line),
      const SizedBox(height: 12),
      Row(
        children: [
          if (sync.isSyncing)
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: tt.muted),
            )
          else
            Icon(
              sync.status == SyncStatus.error ? Icons.error_outline : Icons.check_circle_outline,
              size: 16,
              color: sync.status == SyncStatus.error ? Colors.redAccent : tt.muted,
            ),
          const SizedBox(width: 8),
          Expanded(
            child:
                Text(_syncStatusText(sync, l10n), style: TextStyle(fontSize: 13, color: tt.muted)),
          ),
        ],
      ),
      // 同步被会员门控挡下时，就地给出开通入口（支付通道关闭时隐藏）
      if (sync.status == SyncStatus.error &&
          sync.lastError == SyncError.premiumRequired &&
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
            child: Text(l10n.proSubscribeBtn, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
      ],
      const SizedBox(height: 14),
      SizedBox(
        width: double.infinity,
        height: 46,
        child: ElevatedButton(
          onPressed:
              (!session.syncEnabled || sync.isSyncing) ? null : () => sync.syncNow(),
          style: ElevatedButton.styleFrom(
            backgroundColor: tt.ink,
            foregroundColor: tt.page,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(sync.isSyncing ? l10n.syncStatusSyncing : l10n.syncNowBtn,
              style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
      ),
    ]);
  }

  Widget _card(AppThemeTokens tt, List<Widget> children) {
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

/// 同步卡 + Pro 卡组合（已登录卡片组下半部分）
class SyncSection extends StatelessWidget {
  const SyncSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ProStatusCard(),
        SizedBox(height: AppSpacing.lg),
        SyncStatusCard(),
      ],
    );
  }
}
