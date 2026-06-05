import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../theme/app_theme_tokens.dart';

/// 天气占位卡片（首页）
class HomeWeatherCard extends StatelessWidget {
  final AppThemeTokens tt;

  const HomeWeatherCard({super.key, required this.tt});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-0.77, -0.64),
            end: const Alignment(0.77, 0.64),
            colors: [tt.ink, tt.accent2],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Color(0x12554230), blurRadius: 28, offset: Offset(0, 12))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.weatherPlaceholderLocation,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tt.page.withValues(alpha: 0.8)),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    l10n.weatherPlaceholderAdvice,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: tt.page),
                  ),
                ],
              ),
            ),
            Text(
              '24°',
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.w300, color: tt.page),
            ),
          ],
        ),
      ),
    );
  }
}
