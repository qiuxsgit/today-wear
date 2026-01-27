import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../theme/app_colors.dart';

/// 日期分组标题组件
/// 
/// 用于瀑布流布局中显示日期分组标题
class DateSectionHeader extends StatelessWidget {
  /// 日期
  final DateTime date;
  
  const DateSectionHeader({
    super.key,
    required this.date,
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
    } else if (dateOnly == today.subtract(const Duration(days: 2))) {
      return l10n.dayBeforeYesterday;
    } else {
      return l10n.dateFormat(date.month, date.day);
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
    final dateText = _formatDate(context, date);
    final isToday = _isToday(date);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        dateText,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isToday ? FontWeight.w600 : FontWeight.w500,
          color: isToday ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}
