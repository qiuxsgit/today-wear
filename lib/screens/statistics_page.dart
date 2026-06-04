import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../database/database.dart';
import '../repositories/outfit_repository.dart';
import '../theme/app_theme_tokens.dart';

/// 标签使用百分比：该标签次数 ÷ 全部标签总次数（四舍五入取整，总数为 0 时为 0）
int tagUsagePercent(int count, int totalCount) =>
    totalCount > 0 ? (count / totalCount * 100).round() : 0;

/// 統計頁面
///
/// 主卡：漸層背景 + 圓形進度環
/// 快速數據：最近7天 / 總計
/// 標籤使用頻率：橫向進度條
/// 本月穿搭靈感：水平捲動 chip
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  late final OutfitRepository _repository;

  late final AnimationController _refreshAnimController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  int _monthlyCount = 0;
  int _weeklyCount = 0;
  int _totalCount = 0;
  Map<String, int> _tagStats = {};
  bool _isLoading = true;
  bool _isFirstLoad = true;
  final DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _repository = OutfitRepository(AppDatabase());
    _loadStatistics();
  }

  @override
  void dispose() {
    _refreshAnimController.dispose();
    super.dispose();
  }

  Future<void> _loadStatistics() async {
    if (_isFirstLoad) setState(() => _isLoading = true);

    try {
      final totalCount = await _repository.getTotalCount();
      final monthlyStats = await _repository.getMonthlyStats(
        _currentMonth.year,
        _currentMonth.month,
      );
      final monthlyCount = monthlyStats.values.fold(0, (s, c) => s + c);
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      final weeklyOutfits = await _repository.getOutfitsByDateRange(weekAgo, now);
      final tagStats = await _repository.getTagUsageStats();

      if (!mounted) return;
      setState(() {
        _totalCount = totalCount;
        _monthlyCount = monthlyCount;
        _weeklyCount = weeklyOutfits.length;
        _tagStats = tagStats;
        _isLoading = false;
        _isFirstLoad = false;
      });
    } catch (e) {
      debugPrint('Load statistics error: $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isFirstLoad = false;
      });
    }
  }

  Future<void> _onRefreshPressed() async {
    if (_refreshAnimController.isAnimating) return;
    _refreshAnimController.repeat();
    final start = DateTime.now();

    await _loadStatistics();
    if (!mounted) return;

    final elapsedMs = DateTime.now().difference(start).inMilliseconds;
    if (elapsedMs < 600) {
      await Future.delayed(Duration(milliseconds: 600 - elapsedMs));
      if (!mounted) return;
    }
    final remaining = 1.0 - _refreshAnimController.value;
    final tailMs = (remaining * 600).round().clamp(120, 600);
    await _refreshAnimController.animateTo(
      1.0,
      duration: Duration(milliseconds: tailMs),
      curve: Curves.easeOut,
    );
    if (!mounted) return;
    _refreshAnimController.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: tt.page,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: tt.page,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(tt, l10n),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadStatistics,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMainCard(tt, l10n),
                      const SizedBox(height: 14),
                      _buildQuickStats(tt, l10n),
                      if (_tagStats.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        _buildTagFrequency(tt, l10n),
                        const SizedBox(height: 18),
                        _buildInspirationChips(tt, l10n),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(AppThemeTokens tt, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.statsMonthly,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tt.muted, letterSpacing: 0.3),
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.statsPageTitle,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: tt.ink, height: 1.05),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _onRefreshPressed,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: tt.surface,
                shape: BoxShape.circle,
                border: Border.all(color: tt.line),
                boxShadow: const [BoxShadow(color: Color(0x14554230), blurRadius: 18, offset: Offset(0, 8))],
              ),
              child: RotationTransition(
                turns: _refreshAnimController,
                child: Icon(Icons.refresh_rounded, size: 18, color: tt.muted),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard(AppThemeTokens tt, AppLocalizations l10n) {
    final now = DateTime.now();
    final monthName = l10n.calendarMonthName(now.month.toString());
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final percent = daysInMonth > 0
        ? (_monthlyCount / daysInMonth).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-0.77, -0.64),
          end: const Alignment(0.77, 0.64),
          colors: [tt.ink, tt.accent],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x29554230), blurRadius: 28, offset: Offset(0, 12))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$monthName ${now.year}',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tt.page.withValues(alpha: 0.72)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.statsMonthly,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: tt.page),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_monthlyCount',
                      style: TextStyle(fontSize: 46, fontWeight: FontWeight.w800, color: tt.page, height: 1.05),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.statsRecordedDaysLabel,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tt.page.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
              _CircleProgress(percent: percent, color: tt.page),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(AppThemeTokens tt, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(child: _QuickStatBox(value: '$_weeklyCount', label: l10n.statsLast7Days, tt: tt)),
        const SizedBox(width: 10),
        Expanded(child: _QuickStatBox(value: '$_totalCount', label: l10n.statsTotal, tt: tt)),
      ],
    );
  }

  Widget _buildTagFrequency(AppThemeTokens tt, AppLocalizations l10n) {
    final sorted = _tagStats.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topTags = sorted.take(6).toList();
    final maxCount = topTags.isEmpty ? 1 : topTags.first.value;
    // 百分比 = 該標籤次數 ÷ 全部標籤總次數；進度條寬度按最大值歸一化保持視覺對比
    final totalCount = _tagStats.values.fold(0, (s, c) => s + c);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.statsTagFrequency,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: tt.ink),
        ),
        const SizedBox(height: 12),
        ...topTags.map((entry) {
          final barPct = maxCount > 0 ? (entry.value / maxCount) : 0.0;
          final pctInt = tagUsagePercent(entry.value, totalCount);
          return Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tt.ink)),
                    Text('$pctInt%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tt.muted)),
                  ],
                ),
                const SizedBox(height: 6),
                _TagProgressBar(progress: barPct, tt: tt),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInspirationChips(AppThemeTokens tt, AppLocalizations l10n) {
    final sorted = _tagStats.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topTags = sorted.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.statsInspirationTitle,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: tt.ink),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: topTags.asMap().entries.map((e) {
              final isFirst = e.key == 0;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isFirst ? tt.ink : tt.mist,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    e.value.key,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isFirst ? tt.page : tt.muted,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _CircleProgress extends StatelessWidget {
  final double percent;
  final Color color;
  const _CircleProgress({required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 86,
      height: 86,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(86, 86),
            painter: _CircleProgressPainter(progress: percent, color: color),
          ),
          Text(
            '${(percent * 100).round()}%',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  const _CircleProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 14) / 2;

    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      final fgPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        progress * 2 * math.pi,
        false,
        fgPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CircleProgressPainter old) =>
      old.progress != progress || old.color != color;
}

class _QuickStatBox extends StatelessWidget {
  final String value;
  final String label;
  final AppThemeTokens tt;
  const _QuickStatBox({required this.value, required this.label, required this.tt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: tt.mist,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: tt.ink, height: 1.1)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tt.muted)),
        ],
      ),
    );
  }
}

class _TagProgressBar extends StatelessWidget {
  final double progress;
  final AppThemeTokens tt;
  const _TagProgressBar({required this.progress, required this.tt});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 10,
        color: tt.mist,
        child: FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [tt.ink, tt.accent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
