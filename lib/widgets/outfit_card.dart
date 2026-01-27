import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../models/outfit.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';

/// 穿搭卡片组件
/// 
/// 展示单条穿搭记录，包含照片、日期、描述和标签
class OutfitCard extends StatelessWidget {
  /// 穿搭数据
  final Outfit outfit;
  
  const OutfitCard({
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
      // 使用本地化的日期格式
      final locale = Localizations.localeOf(context);
      final dateFormat = DateFormat('M/d', locale.toString());
      final formatted = dateFormat.format(date);
      
      // 对于中文、日文、韩文，使用自定义格式
      if (locale.languageCode == 'zh' || locale.languageCode == 'ja' || locale.languageCode == 'ko') {
        return l10n.dateFormat(date.month, date.day);
      }
      
      return formatted;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 照片区域
          Container(
            width: double.infinity,
            height: 320,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E8E8), // 占位色
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.image,
                size: 64,
                color: AppColors.textPlaceholder,
              ),
            ),
          ),
          
          // 信息区域
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 日期
                Text(
                  _formatDate(context, outfit.date),
                  style: AppTextStyle.hint,
                ),
                
                const SizedBox(height: AppSpacing.xs),
                
                // 描述
                Text(
                  outfit.description,
                  style: AppTextStyle.title,
                ),
                
                // 标签
                if (outfit.tags.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
