import 'dart:io';
import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';
import '../services/image_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../theme/app_spacing.dart';
import '../services/locale_service.dart';
import 'contact_page.dart';
import 'language_selection_page.dart';
import 'privacy_policy_page.dart';
import 'profile_edit_page.dart';
import 'tag_management_page.dart';
import 'terms_of_service_page.dart';

/// 个人/设置页面
///
/// 包含个人信息、设置选项和关于应用等功能；点击头像或昵称进入资料编辑
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final p = await ProfileService.load();
    if (mounted) setState(() => _profile = p);
  }

  void _openProfileEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditPage(initialProfile: _profile),
      ),
    ).then((_) => _loadProfile());
  }

  Widget _buildAvatar(String? avatarPath) {
    if (avatarPath == null || avatarPath.isEmpty) {
      return Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: AppColors.imagePlaceholder,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.person_outline, size: 32, color: AppColors.textSecondary),
      );
    }
    return FutureBuilder<File?>(
      future: ImageService.instance.getImageFile(avatarPath),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return ClipOval(
            child: Image.file(
              snapshot.data!,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          );
        }
        return Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.imagePlaceholder,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.person_outline, size: 32, color: AppColors.textSecondary),
        );
      },
    );
  }

  /// 构建个人信息卡片
  Widget _buildProfileCard(BuildContext context, AppLocalizations l10n) {
    final p = _profile;
    final displayName = (p?.nickname != null && p!.nickname!.trim().isNotEmpty)
        ? p.nickname!.trim()
        : l10n.nickname;

    return InkWell(
      onTap: _openProfileEdit,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md + 4),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // 头像（图片或默认占位）
            _buildAvatar(p?.avatarPath),
            const SizedBox(height: AppSpacing.md),
            // 昵称
            Text(
              displayName,
              style: AppTextStyle.title.copyWith(fontSize: 18),
            ),
            if (p != null && _hasExtraInfo(p)) ...[
              const SizedBox(height: AppSpacing.sm),
              _buildExtraInfo(context, l10n, p),
            ],
          ],
        ),
      ),
    );
  }

  bool _hasExtraInfo(UserProfile p) {
    return (p.birthday != null) ||
        (p.gender != null && p.gender!.isNotEmpty && p.gender != 'none') ||
        (p.personality != null && p.personality!.trim().isNotEmpty);
  }

  Widget _buildExtraInfo(
      BuildContext context, AppLocalizations l10n, UserProfile p) {
    final parts = <String>[];
    if (p.birthday != null) {
      final d = p.birthday!;
      parts.add('${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}');
    }
    if (p.gender != null && p.gender != 'none' && p.gender!.isNotEmpty) {
      final g = p.gender!;
      if (g == 'male') parts.add(l10n.male);
      if (g == 'female') parts.add(l10n.female);
    }
    if (parts.isEmpty && (p.personality == null || p.personality!.trim().isEmpty)) {
      return const SizedBox.shrink();
    }
    final line1 = parts.isNotEmpty ? parts.join(' · ') : null;
    final line2 = (p.personality != null && p.personality!.trim().isNotEmpty)
        ? p.personality!.trim()
        : null;
    if (line1 == null && line2 == null) return const SizedBox.shrink();

    return Column(
      children: [
        if (line1 != null)
          Text(
            line1,
            style: AppTextStyle.hint.copyWith(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (line2 != null) ...[
          if (line1 != null) const SizedBox(height: 4),
          Text(
            line2,
            style: AppTextStyle.hint.copyWith(fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ],
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
          // 隐私政策
          _buildAboutItem(
            context,
            l10n.privacyPolicy,
            null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyPage(),
                ),
              );
            },
          ),
          // 使用条款
          _buildAboutItem(
            context,
            l10n.termsOfService,
            null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsOfServicePage(),
                ),
              );
            },
          ),
          // 联系方式
          _buildAboutItem(
            context,
            l10n.contact,
            null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactPage(),
                ),
              );
            },
          ),
          // 版本号
          _buildAboutItem(
            context,
            l10n.version,
            version ?? l10n.appVersion,
            showArrow: false,
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
        toolbarHeight: 0,
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
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
