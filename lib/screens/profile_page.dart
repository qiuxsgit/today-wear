import 'dart:io';
import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';
import '../services/image_service.dart';
import '../theme/app_text_style.dart';
import '../theme/app_theme_tokens.dart';
import '../theme/app_spacing.dart';
import '../services/locale_service.dart';
import '../services/theme_service.dart';
import 'appearance_theme_page.dart';
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
    final tt = context.tt;
    if (avatarPath == null || avatarPath.isEmpty) {
      return Container(
        width: 78,
        height: 78,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-0.5, -1),
            end: const Alignment(0.5, 1),
            colors: [tt.accent, tt.ink],
          ),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text('穿', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: tt.page)),
      );
    }
    return FutureBuilder<File?>(
      future: ImageService.instance.getImageFile(avatarPath),
      builder: (context, snapshot) {
        final t = context.tt;
        if (snapshot.hasData && snapshot.data != null) {
          return ClipOval(
            child: Image.file(
              snapshot.data!,
              width: 78,
              height: 78,
              fit: BoxFit.cover,
            ),
          );
        }
        return Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(-0.5, -1),
              end: const Alignment(0.5, 1),
              colors: [t.accent, t.ink],
            ),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text('穿', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: t.page)),
        );
      },
    );
  }

  /// 构建个人信息卡片
  Widget _buildProfileCard(BuildContext context, AppLocalizations l10n) {
    final tt = context.tt;
    final p = _profile;
    final displayName = (p?.nickname != null && p!.nickname!.trim().isNotEmpty)
        ? p.nickname!.trim()
        : l10n.nickname;

    return InkWell(
      onTap: _openProfileEdit,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md + 4),
        decoration: BoxDecoration(
          color: tt.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Color(0x0F554230), blurRadius: 24, offset: Offset(0, 10))],
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
  
  Widget _buildAppearanceTile(BuildContext context) {
    final tt = context.tt;
    final presetName = ThemeService.getPresetName(ThemeService.instance.currentPreset);
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: Text('外觀主題', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: tt.ink)),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppearanceThemePage())),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(presetName, style: TextStyle(fontSize: 13, color: tt.muted)),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, color: tt.muted, size: 18),
              ],
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
    final tt = context.tt;
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
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: BoxDecoration(
        color: tt.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x0F554230), blurRadius: 24, offset: Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.settings, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: tt.ink)),
          const SizedBox(height: 10),
          _buildSettingsRow(tt, l10n.settings, _buildAppearanceTile(context)),
          Divider(height: 1, color: tt.line),
          _buildSettingsNavRow(
            tt: tt,
            label: l10n.tagManagement,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TagManagementPage())),
          ),
          Divider(height: 1, color: tt.line),
          SizedBox(
            height: 48,
            child: Row(
              children: [
                Expanded(
                  child: Text(l10n.language, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: tt.ink)),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageSelectionPage())),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(currentLanguageName, style: TextStyle(fontSize: 13, color: tt.muted)),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: tt.muted, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow(AppThemeTokens tt, String _, Widget child) => child;

  Widget _buildSettingsNavRow({required AppThemeTokens tt, required String label, required VoidCallback onTap}) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: tt.ink))),
          GestureDetector(
            onTap: onTap,
            child: Icon(Icons.chevron_right, color: tt.muted, size: 18),
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
    final tt = context.tt;
    final items = [
      (l10n.privacyPolicy, null as String?, true, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()))),
      (l10n.termsOfService, null, true, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsOfServicePage()))),
      (l10n.contact, null, true, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactPage()))),
      (l10n.version, version ?? l10n.appVersion, false, null as VoidCallback?),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: BoxDecoration(
        color: tt.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x0F554230), blurRadius: 24, offset: Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.about, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: tt.ink)),
          const SizedBox(height: 10),
          ...items.asMap().entries.map((e) {
            final (title, value, showArrow, onTap) = e.value;
            final isLast = e.key == items.length - 1;
            return Column(
              children: [
                SizedBox(
                  height: 46,
                  child: GestureDetector(
                    onTap: onTap,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        Expanded(child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: tt.ink))),
                        if (value != null)
                          Text(value, style: TextStyle(fontSize: 13, color: tt.muted))
                        else if (showArrow)
                          Icon(Icons.chevron_right, color: tt.muted, size: 18),
                      ],
                    ),
                  ),
                ),
                if (!isLast) Divider(height: 1, color: tt.line),
              ],
            );
          }),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeService = LocaleServiceProvider.of(context);
    final currentLocale = localeService?.currentLocale;
    
    final tt = context.tt;
    return Scaffold(
      backgroundColor: tt.page,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: tt.page,
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
            padding: EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: 72 + MediaQuery.of(context).padding.bottom,
            ),
            children: [
              // Topbar
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.profile,
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: tt.ink, height: 1.05),
                      ),
                    ),
                    GestureDetector(
                      onTap: _openProfileEdit,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: tt.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: tt.line),
                          boxShadow: const [BoxShadow(color: Color(0x14554230), blurRadius: 18, offset: Offset(0, 8))],
                        ),
                        child: Icon(Icons.settings_outlined, size: 18, color: tt.muted),
                      ),
                    ),
                  ],
                ),
              ),
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
