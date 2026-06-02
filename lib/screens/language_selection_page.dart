import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../theme/app_spacing.dart';
import '../services/locale_service.dart';

/// 语言选择页面
///
/// 用于选择应用语言
class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeService = LocaleServiceProvider.of(context);
    final currentLocale = localeService?.currentLocale;

    return Scaffold(
      backgroundColor: AppColors.warmPage,
      appBar: AppBar(
        title: Text(l10n.language, style: AppTextStyle.title),
        backgroundColor: AppColors.warmSurface,
        foregroundColor: AppColors.warmInk,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        scrolledUnderElevation: 2,
      ),
      body: RadioGroup<Locale>(
        groupValue: currentLocale,
        onChanged: (value) {
          if (value != null && localeService != null) {
            localeService.setLocale(value);
          }
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: LocaleService.supportedLocales.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.xs),
          itemBuilder: (context, index) {
            final locale = LocaleService.supportedLocales[index];
            final isSelected = currentLocale?.languageCode == locale.languageCode &&
                currentLocale?.countryCode == locale.countryCode;

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
                color: AppColors.warmSurface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: RadioListTile<Locale>(
                title: Text(
                  languageName,
                  style: AppTextStyle.body.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
