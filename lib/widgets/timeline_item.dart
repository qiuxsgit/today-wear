import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../models/outfit.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'outfit_card.dart';

/// 时间轴项组件
/// 
/// 展示一个日期及其对应的穿搭记录
class TimelineItem extends StatelessWidget {
  /// 日期
  final DateTime date;
  
  /// 该日期下的穿搭列表
  final List<Outfit> outfits;
  
  const TimelineItem({
    super.key,
    required this.date,
    required this.outfits,
  });
  
  /// 格式化日期标签
  String _formatDateLabel(BuildContext context, DateTime date) {
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
      
      // 对于中文、日文、韩文，使用自定义格式
      if (locale.languageCode == 'zh' || locale.languageCode == 'ja' || locale.languageCode == 'ko') {
        return l10n.dateFormat(date.month, date.day);
      }
      
      // 对于其他语言，使用intl的日期格式
      final dateFormat = DateFormat('M/d', locale.toString());
      return dateFormat.format(date);
    }
  }
  
  /// 判断是否为今天
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    return dateOnly == today;
  }
  
  @override
  Widget build(BuildContext context) {
    final isToday = _isToday(date);
    final dateLabel = _formatDateLabel(context, date);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 日期标签
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.md,
            bottom: AppSpacing.sm,
          ),
          child: Text(
            dateLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
              color: isToday ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
        
        // 穿搭卡片列表
        ...outfits.map((outfit) {
          return Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.lg,
            ),
            child: OutfitCard(outfit: outfit),
          );
        }),
      ],
    );
  }
}
