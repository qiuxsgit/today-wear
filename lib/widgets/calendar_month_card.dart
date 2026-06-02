import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../theme/app_colors.dart';

/// 日历卡片：白色卡片包裹的月历视图
///
/// 视觉层级：
/// - 选中日期：实心主色圆形 + 白字
/// - 今天（未选中）：浅蓝底圆形 + 主色字 + 加粗
/// - 周末：弱化为主色低透明
/// - 有记录的日期：底部小圆点标记
class CalendarMonthCard extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDay;
  final Map<int, int> monthlyStats;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final ValueChanged<DateTime> onPageChanged;

  const CalendarMonthCard({
    super.key,
    required this.focusedMonth,
    required this.selectedDay,
    required this.monthlyStats,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  bool _hasEvent(DateTime day) {
    if (day.year != focusedMonth.year || day.month != focusedMonth.month) {
      return false;
    }
    return (monthlyStats[day.day] ?? 0) > 0;
  }

  /// 自绘日期单元：32px 圆 + 下方 4px 圆点
  ///
  /// 不再依赖 BoxDecoration 填满整个 cell，所以圆圈不会盖住下面的事件点。
  Widget _buildDay(
    DateTime day, {
    required bool selected,
    required bool today,
  }) {
    final isWeekend =
        day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;

    // 选中态：浅蓝底 + 蓝字（柔和不抢眼）
    // 今天（未选中）：仅蓝色加粗文字，避免与选中态视觉冲突
    // 圆点（事件标记）独立于以上两种状态，永远落在下方
    Color textColor;
    Color? bgColor;
    if (selected) {
      textColor = AppColors.brandBlue;
      bgColor = AppColors.brandBlue.withValues(alpha: 0.12);
    } else if (today) {
      textColor = AppColors.brandBlue;
      bgColor = null;
    } else {
      textColor = isWeekend
          ? AppColors.brandBlue.withValues(alpha: 0.75)
          : AppColors.textPrimaryV2;
      bgColor = null;
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: bgColor != null
                ? BoxDecoration(color: bgColor, shape: BoxShape.circle)
                : null,
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                fontWeight:
                    (selected || today) ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: _hasEvent(day) ? AppColors.brandBlue : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedMonth,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        calendarFormat: CalendarFormat.month,
        availableGestures: AvailableGestures.horizontalSwipe,
        rowHeight: 52,
        daysOfWeekHeight: 28,
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (_, day, _) =>
              _buildDay(day, selected: false, today: false),
          selectedBuilder: (_, day, _) =>
              _buildDay(day, selected: true, today: false),
          todayBuilder: (_, day, _) =>
              _buildDay(day, selected: false, today: true),
          markerBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          headerPadding: EdgeInsets.symmetric(vertical: 4),
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryV2,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            size: 22,
            color: AppColors.textSecondaryV2,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            size: 22,
            color: AppColors.textSecondaryV2,
          ),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondaryV2,
          ),
          weekendStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.brandBlue,
          ),
        ),
        calendarStyle: const CalendarStyle(
          outsideDaysVisible: false,
          cellMargin: EdgeInsets.all(2),
        ),
      ),
    );
  }
}
