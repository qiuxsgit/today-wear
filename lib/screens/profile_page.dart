import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../theme/app_spacing.dart';
import '../services/locale_service.dart';
import 'language_selection_page.dart';
import 'tag_management_page.dart';

/// 个人/设置页面
/// 
/// 包含个人信息、设置选项和关于应用等功能
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  
  /// 构建个人信息卡片
  Widget _buildProfileCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md + 4), // 20
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 头像占位符
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.imagePlaceholder,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // 昵称
          Text(
            l10n.nickname,
            style: AppTextStyle.title.copyWith(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建设置卡片
  Widget _buildSettingsCard(
    BuildContext context,
    AppLocalizations l10n,
    Locale? currentLocale,
  ) {
    // 获取当前语言名称
    String currentLanguageName;
    if (currentLocale != null) {
      switch (currentLocale.languageCode) {
        case 'zh':
          currentLanguageName = currentLocale.countryCode == 'CN'
              ? l10n.simplifiedChinese
              : l10n.traditionalChinese;
          break;
        case 'en':
          currentLanguageName = l10n.english;
          break;
        case 'ja':
          currentLanguageName = l10n.japanese;
          break;
        case 'ko':
          currentLanguageName = l10n.korean;
          break;
        default:
          currentLanguageName = currentLocale.languageCode;
      }
    } else {
      currentLanguageName = l10n.english;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 设置标题
          Text(
            l10n.settings,
            style: AppTextStyle.title.copyWith(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // 标签管理
          Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Text(
                l10n.tagManagement,
                style: AppTextStyle.body.copyWith(
                  fontSize: 16,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TagManagementPage(),
                  ),
                );
              },
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
              ),
              dense: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // 语言选择项
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Text(
                l10n.language,
                style: AppTextStyle.body.copyWith(
                  fontSize: 16,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentLanguageName,
                    style: AppTextStyle.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguageSelectionPage(),
                  ),
                );
              },
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
              ),
              dense: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建关于应用卡片
  Widget _buildAboutCard(
    BuildContext context,
    AppLocalizations l10n,
    String? version,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 关于应用标题
          Text(
            l10n.about,
            style: AppTextStyle.title.copyWith(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // 版本号
          _buildAboutItem(
            context,
            l10n.version,
            version ?? l10n.appVersion,
            showArrow: false,
          ),
          // 隐私政策
          _buildAboutItem(
            context,
            l10n.privacyPolicy,
            null,
            onTap: () {
              // TODO: 打开隐私政策页面或链接
            },
          ),
          // 使用条款
          _buildAboutItem(
            context,
            l10n.termsOfService,
            null,
            onTap: () {
              // TODO: 打开使用条款页面或链接
            },
          ),
          // 开源许可
          _buildAboutItem(
            context,
            l10n.openSourceLicense,
            null,
            onTap: () {
              // TODO: 打开开源许可页面或链接
            },
          ),
          // 联系方式
          _buildAboutItem(
            context,
            l10n.contact,
            null,
            onTap: () {
              // TODO: 打开联系方式或反馈对话框
            },
          ),
        ],
      ),
    );
  }
  
  /// 构建关于应用列表项
  Widget _buildAboutItem(
    BuildContext context,
    String title,
    String? value, {
    bool showArrow = true,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          title,
          style: AppTextStyle.body,
        ),
        trailing: value != null
            ? Text(
                value,
                style: AppTextStyle.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            : showArrow
                ? const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: 20,
                  )
                : null,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
        ),
        dense: true,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeService = LocaleServiceProvider.of(context);
    final currentLocale = localeService?.currentLocale;
    
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text(l10n.profile, style: AppTextStyle.title),
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
      ),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final version = snapshot.hasData
              ? snapshot.data!.version
              : null;
          
          return ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: AppSpacing.md,
            ),
            children: [
              const SizedBox(height: AppSpacing.md),
              // 个人信息卡片
              _buildProfileCard(context, l10n),
              const SizedBox(height: AppSpacing.lg),
              // 设置卡片
              _buildSettingsCard(context, l10n, currentLocale),
              const SizedBox(height: AppSpacing.lg),
              // 关于应用卡片
              _buildAboutCard(context, l10n, version),
              const SizedBox(height: AppSpacing.lg),
            ],
          );
        },
      ),
    );
  }
}
