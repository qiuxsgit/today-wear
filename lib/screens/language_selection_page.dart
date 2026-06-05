import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../api/user_api.dart';
import '../services/session_service.dart';
import '../theme/app_text_style.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_tokens.dart';
import '../services/locale_service.dart';

/// 语言选择页面
///
/// 用于选择应用语言
class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tt = context.tt;
    final localeService = LocaleServiceProvider.of(context);
    // 若用户尚未手动选择语言，回退到系统语言，确保列表中有勾选项
    final currentLocale = localeService?.currentLocale ??
        LocaleService.getSystemLocale(
          WidgetsBinding.instance.platformDispatcher.locales,
        );

    return Scaffold(
      backgroundColor: tt.page,
      appBar: AppBar(
        title: Text(l10n.language, style: AppTextStyle.title.copyWith(color: tt.ink)),
        backgroundColor: tt.surface,
        foregroundColor: tt.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        scrolledUnderElevation: 2,
      ),
      body: RadioGroup<Locale>(
        groupValue: currentLocale,
        onChanged: (value) {
          if (value != null && localeService != null) {
            localeService.setLocale(value);
            // 已登录时后台同步语言偏好到服务端（失败不打扰用户）
            if (SessionService.instance.isLoggedIn) {
              UserApi()
                  .updateLanguage(LocaleService.toApiTag(value))
                  .catchError((e) {
                debugPrint('Language sync failed: $e');
              });
            }
          }
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: LocaleService.supportedLocales.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.xs),
          itemBuilder: (context, index) {
            final locale = LocaleService.supportedLocales[index];
            final isSelected = currentLocale.languageCode == locale.languageCode &&
                currentLocale.countryCode == locale.countryCode;

            String languageName;
            switch (locale.languageCode) {
              case 'zh':
                languageName = locale.countryCode == 'CN'
                    ? l10n.simplifiedChinese
                    : l10n.traditionalChinese;
                break;
              case 'en':
                languageName = l10n.english;
                break;
              case 'ja':
                languageName = l10n.japanese;
                break;
              case 'ko':
                languageName = l10n.korean;
                break;
              default:
                languageName = locale.languageCode;
            }

            return Container(
              decoration: BoxDecoration(
                color: tt.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: RadioListTile<Locale>(
                title: Text(
                  languageName,
                  style: AppTextStyle.body.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: tt.ink,
                  ),
                ),
                value: locale,
                selected: isSelected,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
