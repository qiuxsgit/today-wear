import 'dart:io';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../database/database.dart';
import '../repositories/outfit_repository.dart';
import '../models/outfit.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import 'outfit_detail_page.dart';
import 'add_outfit_page.dart';

/// 日历页面
///
/// 展示月历视图，显示每日穿搭状态
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  /// 当前选中的日期
  DateTime _selectedDay = DateTime.now();
  
  /// 日历聚焦的月份
  DateTime _focusedMonth = DateTime.now();
  
  /// 日历格式（月/周）
  CalendarFormat _calendarFormat = CalendarFormat.month;
  
  /// 月度穿搭统计数据（day -> count）
  Map<int, int> _monthlyStats = {};
  
  /// 选中日期的穿搭列表
  List<Outfit> _selectedDayOutfits = [];
  
  /// 是否正在加载
  bool _isLoading = false;
  
  /// 数据库仓库
  late final OutfitRepository _repository;
  
  @override
  void initState() {
    super.initState();
    _initializeRepository();
    _loadMonthlyStats();
  }
  
  /// 初始化仓库
  void _initializeRepository() {
    final db = AppDatabase();
    _repository = OutfitRepository(db);
  }
  
  /// 加载月度统计数据
  Future<void> _loadMonthlyStats() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final stats = await _repository.getMonthlyStats(
        _focusedMonth.year,
        _focusedMonth.month,
      );
      
      if (!mounted) return;
      
      setState(() {
        _monthlyStats = stats;
        _isLoading = false;
      });
      
      // 加载选中日期的穿搭
      await _loadSelectedDayOutfits();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  /// 加载选中日期的穿搭列表
  Future<void> _loadSelectedDayOutfits() async {
    try {
      final outfits = await _repository.getOutfitsByDateRange(
        DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day),
        DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, 23, 59, 59),
      );
      
      if (!mounted) return;
      
      setState(() {
        _selectedDayOutfits = outfits;
      });
    } catch (e) {
      debugPrint('Load selected day outfits error: $e');
    }
  }
  
  /// 处理日期选择
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedMonth = focusedDay;
      });
      _loadSelectedDayOutfits();
    }
  }
  
  /// 处理月份变化
  void _onMonthChanged(DateTime focusedDay) {
    setState(() {
      _focusedMonth = focusedDay;
    });
    _loadMonthlyStats();
  }
  
  /// 获取日历标记构建器
  Widget Function(DateTime)? _getCalendarBuilders() {
    return (day) {
      final dayCount = _monthlyStats[day.day] ?? 0;
      
      if (dayCount > 0) {
        // 有穿搭记录的日期，显示标记
        return Positioned(
          right: 6,
          bottom: 6,
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        );
      }
      return null;
    };
  }
  
  /// 构建日历标记
  List<Widget> _buildCalendarMarkers(DateTime day) {
    final dayCount = _monthlyStats[day.day] ?? 0;
    
    if (dayCount > 0) {
      return [
        Positioned(
          right: 6,
          bottom: 6,
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ];
    }
    return [];
  }
  
  /// 构建日期标题
  Widget _buildDateHeader() {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final isToday = isSameDay(_selectedDay, now);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_selectedDay.year}/${_selectedDay.month.toString().padLeft(2, '0')}/${_selectedDay.day.toString().padLeft(2, '0')}',
            style: AppTextStyle.body.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            children: [
              if (isToday)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l10n.today,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              if (isToday) const SizedBox(width: AppSpacing.xs),
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 20),
                onPressed: () {
                  final previousDay = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day - 1);
                  _onDaySelected(previousDay, previousDay);
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 20),
                onPressed: () {
                  final nextDay = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day + 1);
                  _onDaySelected(nextDay, nextDay);
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// 构建穿搭列表
  Widget _buildOutfitList() {
    final l10n = AppLocalizations.of(context)!;
    
    if (_selectedDayOutfits.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Icon(
              Icons.checkroom_outlined,
              size: 48,
              color: AppColors.textPlaceholder,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.calendarNoOutfits,
              style: AppTextStyle.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddOutfitPage(initialDate: _selectedDay),
                  ),
                );
                if (result == true) {
                  _loadMonthlyStats();
                  _loadSelectedDayOutfits();
                }
              },
              icon: const Icon(Icons.add, size: 18),
              label: Text(l10n.calendarAddOutfit),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: _selectedDayOutfits.length,
      itemBuilder: (context, index) {
        final outfit = _selectedDayOutfits[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: outfit.photoPaths.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(
                      File(outfit.photoPaths.first),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: AppColors.bgTertiary,
                          child: const Icon(Icons.image, size: 24),
                        );
                      },
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: AppColors.bgTertiary,
                    child: const Icon(Icons.checkroom, size: 24),
                  ),
            title: Text(
              outfit.description.isNotEmpty
                  ? outfit.description
                  : l10n.outfitNoDescription,
              style: AppTextStyle.body.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: outfit.tags.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: outfit.tags
                          .take(3)
                          .map((tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.bgTertiary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  )
                : null,
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () async {
              final deleted = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => OutfitDetailPage(outfit: outfit),
                ),
              );
              if (deleted == true) {
                _loadMonthlyStats();
                _loadSelectedDayOutfits();
              }
            },
          ),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        title: Text(l10n.calendar),
        backgroundColor: AppColors.bgPrimary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              final now = DateTime.now();
              _onDaySelected(now, now);
            },
            tooltip: l10n.today,
          ),
        ],
      ),
      body: Column(
        children: [
          // 日期导航
          _buildDateHeader(),
          
          // 日历
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedMonth,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: (day) => _buildCalendarMarkers(day),
              onDaySelected: _onDaySelected,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: _onMonthChanged,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                leftChevronIcon: Icon(Icons.chevron_left, size: 20),
                rightChevronIcon: Icon(Icons.chevron_right, size: 20),
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: const TextStyle(color: AppColors.textSecondary),
                holidayTextStyle: const TextStyle(color: AppColors.error),
                selectedDecoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 3,
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                weekendStyle: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          
          const Divider(height: 1),
          
          // 穿搭列表
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildOutfitList(),
          ),
        ],
      ),
    );
  }
}
