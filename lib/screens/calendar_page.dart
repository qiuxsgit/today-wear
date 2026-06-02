import 'dart:io';
import 'package:flutter/material.dart';
import '../database/database.dart';
import '../repositories/outfit_repository.dart';
import '../models/outfit.dart';
import '../theme/app_text_style.dart';
import '../theme/app_theme_tokens.dart';
import '../widgets/calendar_month_card.dart';
import '../widgets/outfit_record_card.dart';
import '../services/image_service.dart';
import 'outfit_detail_page.dart';
import 'add_outfit_page.dart';

/// 日历页面 — 月度回顧設計
///
/// 結構：自訂 topbar + 月曆卡片 + 統計數字 + 本月最常穿排名
/// 點選日期 → 底部彈出當天穿搭列表
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  Map<int, int> _monthlyStats = {};
  Map<String, int> _monthlyTagStats = {};
  Map<String, String?> _tagFirstPhoto = {};
  int _recordedDaysCount = 0;
  int _uniqueTagsCount = 0;
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
      final (tagStats, tagPhoto) = await _repository.getMonthlyTagStats(
        _focusedMonth.year,
        _focusedMonth.month,
      );
      if (!mounted) return;
      setState(() {
        _monthlyStats = stats;
        _monthlyTagStats = tagStats;
        _tagFirstPhoto = tagPhoto;
        _recordedDaysCount = stats.values.where((c) => c > 0).length;
        _uniqueTagsCount = tagStats.length;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      debugPrint('Load monthly stats error: $e');
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedMonth = focusedDay;
    });
    _showDaySheet(selectedDay);
  }

  void _onMonthChanged(DateTime focusedDay) {
    setState(() => _focusedMonth = focusedDay);
    _loadMonthlyStats();
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
    if (saved == true) _loadMonthlyStats();
  }

  Future<void> _showDaySheet(DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day, 23, 59, 59);
    final outfits = await _repository.getOutfitsByDateRange(start, end);
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DaySheet(
        day: day,
        outfits: outfits,
        onOutfitTap: (outfit) async {
          Navigator.pop(context);
          await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => OutfitDetailPage(
                outfit: outfit,
                onOutfitChanged: _loadMonthlyStats,
              ),
            ),
          );
          _loadMonthlyStats();
        },
        onAddTap: () {
          Navigator.pop(context);
          _openAddOutfit();
        },
      ),
    );
  }

  static const _monthNames = ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'];

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    final ink = tt.ink;
    final muted = tt.muted;
    final page = tt.page;
    final surface = tt.surface;

    final topTags = _monthlyTagStats.entries.take(3).toList();
    final maxCount = topTags.isEmpty ? 1 : topTags.first.value;

    return Scaffold(
      backgroundColor: page,
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  // Topbar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Wardrobe review', style: AppTextStyle.eyebrow.copyWith(color: muted)),
                                const SizedBox(height: 3),
                                Text(
                                  '${_monthNames[_focusedMonth.month - 1]}回顧',
                                  style: AppTextStyle.displayTitle.copyWith(color: ink),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: tt.line),
                            ),
                            child: Icon(Icons.ios_share_outlined, size: 18, color: muted),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // 月曆卡片
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

                  const SliverToBoxAdapter(child: SizedBox(height: 14)),

                  // 統計數字
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Expanded(
                            child: _StatBox(
                              value: '$_recordedDaysCount',
                              label: '已記錄天數',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatBox(
                              value: '$_uniqueTagsCount',
                              label: '常用標籤數',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 本月最常穿
                  if (topTags.isNotEmpty) ...[
                    const SliverToBoxAdapter(child: SizedBox(height: 14)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 9),
                        child: Text(
                          '本月最常穿',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: ink),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList.separated(
                        itemCount: topTags.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 9),
                        itemBuilder: (_, i) {
                          final tag = topTags[i].key;
                          final count = topTags[i].value;
                          final score = ((count / maxCount) * 100).round();
                          return _RankItem(
                            tagName: tag,
                            count: count,
                            score: score,
                            photoPath: _tagFirstPhoto[tag],
                          );
                        },
                      ),
                    ),
                  ],

                  const SliverToBoxAdapter(child: SizedBox(height: 110)),
                ],
              ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  const _StatBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: tt.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x0F554230), blurRadius: 18, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: tt.ink)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tt.muted)),
        ],
      ),
    );
  }
}

class _RankItem extends StatelessWidget {
  final String tagName;
  final int count;
  final int score;
  final String? photoPath;
  const _RankItem({
    required this.tagName,
    required this.count,
    required this.score,
    required this.photoPath,
  });

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: tt.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: _MiniLook(photoPath: photoPath, accent: tt.accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tagName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tt.ink)),
                const SizedBox(height: 3),
                Text('搭配 $count 次', style: TextStyle(fontSize: 11, color: tt.muted)),
              ],
            ),
          ),
          Text('$score', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: tt.accent)),
        ],
      ),
    );
  }
}

class _MiniLook extends StatelessWidget {
  final String? photoPath;
  final Color accent;
  const _MiniLook({this.photoPath, required this.accent});

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(colors: [accent, Color.lerp(accent, Colors.black, 0.35)!]);
    if (photoPath == null) {
      return Container(width: 42, height: 42, decoration: BoxDecoration(gradient: gradient));
    }
    return FutureBuilder<File?>(
      future: ImageService.instance.getImageFile(photoPath!),
      builder: (_, snap) {
        final file = snap.data;
        if (file == null || !file.existsSync()) {
          return Container(width: 42, height: 42, decoration: BoxDecoration(gradient: gradient));
        }
        return Image.file(file, width: 42, height: 42, fit: BoxFit.cover);
      },
    );
  }
}

class _DaySheet extends StatelessWidget {
  final DateTime day;
  final List<Outfit> outfits;
  final ValueChanged<Outfit> onOutfitTap;
  final VoidCallback onAddTap;

  const _DaySheet({
    required this.day,
    required this.outfits,
    required this.onOutfitTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    final surface = tt.surface;
    final ink = tt.ink;
    final muted = tt.muted;

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 36, height: 4, decoration: BoxDecoration(color: tt.line, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${day.month}月${day.day}日穿搭', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: ink)),
                if (outfits.isEmpty)
                  GestureDetector(
                    onTap: onAddTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(999)),
                      child: Text('新增', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: surface)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (outfits.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Text('這天還沒有穿搭記錄', style: TextStyle(color: muted)),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                itemCount: outfits.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) => OutfitRecordCard(
                  outfit: outfits[i],
                  onTap: () => onOutfitTap(outfits[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
