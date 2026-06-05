import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_tokens.dart';
import 'pro_status_card.dart';

/// 未登录状态卡片
///
/// 展示云同步介绍文案及登录/注册入口按钮，点击时回调父页面执行跳转。
class AccountLoggedOutCard extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const AccountLoggedOutCard({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
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
              onPressed: onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: tt.ink,
                foregroundColor: tt.page,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child:
                  Text(l10n.authLoginTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: onRegister,
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
      ],
    );
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: children),
    );
  }
}
