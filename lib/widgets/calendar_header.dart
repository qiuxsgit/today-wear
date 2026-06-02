import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 日历页顶部 Header
///
/// - 浅色品牌渐变背景，奠定页面情绪
/// - 主标题：完整日期 + 星期
/// - 副标题：根据时段给出一句轻提示文案
class CalendarHeader extends StatelessWidget {
  final DateTime selectedDay;

  const CalendarHeader({super.key, required this.selectedDay});

  String get _weekdayLabel {
    const labels = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return labels[selectedDay.weekday - 1];
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 6) return '夜深了，记得早点休息';
    if (hour < 11) return '早安，今天想穿什么呢？';
    if (hour < 14) return '中午好，记录一下今天的穿搭吧';
    if (hour < 18) return '今天适合记录生活';
    if (hour < 22) return '晚上好，回顾今日穿搭';
    return '今天辛苦了';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandBlue.withValues(alpha: 0.10),
            AppColors.brandBlue.withValues(alpha: 0.02),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${selectedDay.year}年${selectedDay.month}月${selectedDay.day}日 · $_weekdayLabel',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryV2,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _greeting,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondaryV2,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
