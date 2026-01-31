import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../theme/app_spacing.dart';

/// 隐私政策页面
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text(l10n.privacyPolicy),
        backgroundColor: AppColors.bgPrimary,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Card(
          color: AppColors.bgSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '隐私政策',
                  style: AppTextStyle.title.copyWith(fontSize: 20),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildSection(
                  '1. 信息收集',
                  '本应用尊重并保护所有用户的个人隐私。我们不会主动收集您的任何个人信息。应用仅在本地设备上存储您自己添加的穿搭数据，这些数据完全保留在您的设备中。',
                ),
                _buildSection(
                  '2. 数据安全',
                  '您的穿搭记录和其他数据均存储在本地设备上，不会上传至任何服务器。我们采用本地数据库进行数据管理，确保您的数据安全。',
                ),
                _buildSection(
                  '3. 应用权限',
                  '本应用可能需要以下权限：\n\n• 相机权限：用于拍摄穿搭照片（可选）\n• 存储权限：用于保存或读取穿搭图片（可选）\n\n所有权限均为可选，拒绝授权不会影响应用的基本功能。',
                ),
                _buildSection(
                  '4. 第三方服务',
                  '本应用不包含任何第三方分析工具、广告或数据追踪服务。我们不会向任何第三方分享您的个人信息。',
                ),
                _buildSection(
                  '5. 儿童隐私保护',
                  '本应用面向成人用户设计，无意收集13岁以下儿童的任何个人信息。',
                ),
                _buildSection(
                  '6. 隐私政策更新',
                  '如需变更本隐私政策，我们会在应用内进行通知。继续使用应用即表示您同意更新后的隐私政策。',
                ),
                _buildSection(
                  '7. 联系我们',
                  '如果您对本隐私政策有任何疑问，请通过应用内的联系方式与我们沟通。',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.title.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            content,
            style: AppTextStyle.body.copyWith(
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}