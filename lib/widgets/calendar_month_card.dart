import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme_tokens.dart';

/// 日历月视图卡片 — 暖色风格
///
/// - 今日：warmInk 实心圆 + 浅色字
/// - 选中：warmMist 底 + warmInk 字
/// - 有记录：warmClay 小圆点
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

  Widget _buildDay(
    DateTime day, {
    required bool selected,
    required bool today,
    required AppThemeTokens tt,
  }) {
    Color textColor;
    Color? bgColor;

    if (today) {
      textColor = tt.surface;
      bgColor = tt.ink;
    } else if (selected) {
      textColor = tt.ink;
      bgColor = tt.mist;
    } else {
      textColor = tt.ink;
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
                fontWeight: (selected || today) ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: _hasEvent(day) ? tt.accent : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-0.5, -1),
          end: const Alignment(0.5, 1),
          colors: [tt.surface, Color.lerp(tt.surface, tt.mist, 0.6)!],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A554230),
            blurRadius: 28,
            offset: Offset(0, 10),
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
              _buildDay(day, selected: false, today: false, tt: tt),
          selectedBuilder: (_, day, _) =>
              _buildDay(day, selected: true, today: false, tt: tt),
          todayBuilder: (_, day, _) =>
              _buildDay(day, selected: false, today: true, tt: tt),
          markerBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          headerPadding: const EdgeInsets.symmetric(vertical: 4),
          titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: tt.ink),
          leftChevronIcon:  Icon(Icons.chevron_left,  size: 22, color: tt.muted),
          rightChevronIcon: Icon(Icons.chevron_right, size: 22, color: tt.muted),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: tt.muted),
          weekendStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: tt.muted),
        ),
        calendarStyle: const CalendarStyle(
          outsideDaysVisible: false,
          cellMargin: EdgeInsets.all(2),
        ),
      ),
    );
  }
}
