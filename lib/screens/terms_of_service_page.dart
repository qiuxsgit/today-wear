import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../theme/app_spacing.dart';

/// 使用条款页面
class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text(l10n.termsOfService),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        scrolledUnderElevation: 2,
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
                  '使用条款',
                  style: AppTextStyle.title.copyWith(fontSize: 20),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildSection(
                  '1. 接受条款',
                  '使用本应用即表示您已阅读、理解并同意遵守本使用条款。如果您不同意这些条款，请勿使用本应用。',
                ),
                _buildSection(
                  '2. 应用描述',
                  '本应用是一个个人穿搭记录工具，旨在帮助用户记录和管理日常穿搭。用户可以添加、编辑和删除自己的穿搭记录。',
                ),
                _buildSection(
                  '3. 用户责任',
                  '用户应对其在本应用中的行为负责。用户承诺：\n\n• 不上传任何非法、有害或侵犯他人权益的内容\n• 合理使用应用功能，不进行恶意操作\n• 对自己添加的数据内容承担责任',
                ),
                _buildSection(
                  '4. 数据存储',
                  '本应用的所有数据均存储在用户的本地设备上，不在云端服务器保存。用户有责任备份重要数据以防丢失。',
                ),
                _buildSection(
                  '5. 知识产权',
                  '本应用的软件、界面设计、图标等内容的知识产权归开发者所有。未经许可，不得复制、修改或分发。',
                ),
                _buildSection(
                  '6. 免责声明',
                  '本应用按"现状"提供，开发者尽力确保应用正常运行，但不保证：\n\n• 应用功能完全无缺陷\n• 数据永不丢失\n• 应用始终可用\n\n用户使用本应用的风险由其自行承担。',
                ),
                _buildSection(
                  '7. 服务变更与终止',
                  '开发者保留随时修改或停止提供本应用服务的权利，恕不另行通知。在这种情况下，用户仍可访问其本地数据。',
                ),
                _buildSection(
                  '8. 条款修改',
                  '开发者可能随时更新本使用条款。修改后的条款将在应用中发布。继续使用应用即表示接受修改后的条款。',
                ),
                _buildSection(
                  '9. 法律适用',
                  '本使用条款受中华人民共和国法律管辖。因使用本应用产生的争议，双方应友好协商解决；协商不成的，提交有管辖权的人民法院处理。',
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