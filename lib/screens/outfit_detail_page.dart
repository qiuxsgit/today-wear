import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../models/outfit.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';

/// 穿搭详情页（占位）
/// 
/// 显示穿搭基本信息，后续再实现完整功能
class OutfitDetailPage extends StatelessWidget {
  /// 穿搭数据
  final Outfit outfit;
  
  const OutfitDetailPage({
    super.key,
    required this.outfit,
  });
  
  /// 格式化日期显示
  String _formatDate(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly == today) {
      return l10n.today;
    } else if (dateOnly == today.subtract(const Duration(days: 1))) {
      return l10n.yesterday;
    } else {
      return l10n.dateFormat(date.month, date.day);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateText = _formatDate(context, outfit.date);
    
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text(dateText, style: AppTextStyle.title),
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 图片占位符
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: AppColors.imagePlaceholder,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: 64,
                    color: AppColors.textPlaceholder,
                  ),
                ),
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              // 描述
              Text(
                outfit.description,
                style: AppTextStyle.title,
              ),
              
              // 标签
              if (outfit.tags.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: outfit.tags.map((tag) {
                    return Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      backgroundColor: AppColors.bgSecondary,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              ],
              
              const SizedBox(height: AppSpacing.lg),
              
              // 占位提示
              Text(
                '详情页功能待实现',
                style: AppTextStyle.hint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
