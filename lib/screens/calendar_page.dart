import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../database/database.dart';
import '../repositories/outfit_repository.dart';
import '../models/outfit.dart';
import '../theme/app_colors.dart';
import '../widgets/calendar_header.dart';
import '../widgets/calendar_month_card.dart';
import '../widgets/outfit_record_card.dart';
import 'outfit_detail_page.dart';
import 'add_outfit_page.dart';

/// 日历页面 — V2 现代卡片化设计
///
/// 结构：
/// - Header（渐变 + 日期 + 提示）
/// - 日历卡片（白卡 + 阴影 + 强化今日/选中态）
/// - 当日穿搭分组（卡片列表 / 空态）
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  Map<int, int> _monthlyStats = {};
  List<Outfit> _selectedDayOutfits = [];
  bool _isLoading = false;

  late final OutfitRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = OutfitRepository(AppDatabase());
    _loadMonthlyStats();
  }

  Future<void> _loadMonthlyStats() async {
    setState(() => _isLoading = true);
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
      await _loadSelectedDayOutfits();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      debugPrint('Load monthly stats error: $e');
    }
  }

  Future<void> _loadSelectedDayOutfits() async {
    try {
      final start = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
      );
      final end = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
        23,
        59,
        59,
      );
      final outfits = await _repository.getOutfitsByDateRange(start, end);
      if (!mounted) return;
      setState(() => _selectedDayOutfits = outfits);
    } catch (e) {
      debugPrint('Load selected day outfits error: $e');
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedMonth = focusedDay;
      });
      _loadSelectedDayOutfits();
    }
  }

  void _onMonthChanged(DateTime focusedDay) {
    setState(() => _focusedMonth = focusedDay);
    _loadMonthlyStats();
  }

  void _jumpToToday() {
    final now = DateTime.now();
    setState(() {
      _selectedDay = now;
      _focusedMonth = now;
    });
    _loadMonthlyStats();
  }

  Future<void> _openOutfitDetail(Outfit outfit) async {
    final deleted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => OutfitDetailPage(outfit: outfit)),
    );
    if (deleted == true) {
      _loadMonthlyStats();
    }
  }

  Future<void> _openAddOutfit() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (ctx) => AddOutfitPage(
          onDataSaved: () => Navigator.of(ctx).pop(true),
        ),
      ),
    );
    if (saved == true) {
      _loadMonthlyStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  CalendarHeader(selectedDay: _selectedDay),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: IconButton(
                      icon: const Icon(
                        Icons.today,
                        color: AppColors.brandBlue,
                      ),
                      tooltip: '回到今天',
                      onPressed: _jumpToToday,
                    ),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 4)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: CalendarMonthCard(
                  focusedMonth: _focusedMonth,
                  selectedDay: _selectedDay,
                  monthlyStats: _monthlyStats,
                  onDaySelected: _onDaySelected,
                  onPageChanged: _onMonthChanged,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: _SectionTitle(count: _selectedDayOutfits.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            if (_isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_selectedDayOutfits.isEmpty)
              SliverToBoxAdapter(
                child: _EmptyState(onAddTap: _openAddOutfit),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                sliver: SliverList.separated(
                  itemCount: _selectedDayOutfits.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final outfit = _selectedDayOutfits[index];
                    return OutfitRecordCard(
                      outfit: outfit,
                      onTap: () => _openOutfitDetail(outfit),
                    );
                  },
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final int count;
  const _SectionTitle({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          '当日穿搭',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryV2,
          ),
        ),
        const SizedBox(width: 8),
        if (count > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.brandBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.brandBlue,
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAddTap;
  const _EmptyState({required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.brandBlue.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.checkroom_outlined,
              size: 30,
              color: AppColors.brandBlue,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '当日还没有穿搭记录',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondaryV2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '记录一下，把每一天的自己留下来',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondaryV2,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onAddTap,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('记录今日穿搭'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.brandBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
