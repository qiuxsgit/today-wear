import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import '../database/database.dart';
import '../repositories/outfit_repository.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';

/// 统计页面
///
/// 展示月度穿搭统计、标签使用频率等数据
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  /// 数据库仓库
  late final OutfitRepository _repository;

  /// 刷新按钮旋转动画控制器（600ms 一圈）
  /// 用 late final + 声明处初始化：首次 build 时懒加载，对 hot reload 也安全
  late final AnimationController _refreshAnimController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  
  /// 月度穿搭数量
  int _monthlyCount = 0;
  
  /// 周度穿搭数量
  int _weeklyCount = 0;
  
  /// 总穿搭数量
  int _totalCount = 0;
  
  /// 标签使用频率统计 (标签名 -> 使用次数)
  Map<String, int> _tagStats = {};
  
  /// 是否正在加载
  bool _isLoading = true;

  /// 是否为首次加载（用于区分初始加载和刷新）
  bool _isFirstLoad = true;

  /// 当前统计月份
  DateTime _currentMonth = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    _initializeRepository();
    _loadStatistics();
  }

  @override
  void dispose() {
    _refreshAnimController.dispose();
    super.dispose();
  }

  /// 初始化仓库
  void _initializeRepository() {
    final db = AppDatabase();
    _repository = OutfitRepository(db);
  }
  
  /// 加载统计数据
  Future<void> _loadStatistics() async {
    // 只在首次加载时显示全屏 loading，刷新时由 RefreshIndicator 处理
    if (_isFirstLoad) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // 加载总数
      final totalCount = await _repository.getTotalCount();

      // 加载月度统计
      final monthlyStats = await _repository.getMonthlyStats(
        _currentMonth.year,
        _currentMonth.month,
      );
      final monthlyCount = monthlyStats.values.fold(0, (sum, count) => sum + count);

      // 加载周度统计（最近 7 天）
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      final weeklyOutfits = await _repository.getOutfitsByDateRange(weekAgo, now);

      // 加载标签统计
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
  
  /// 切换月份
  void _changeMonth(int delta) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + delta, 1);
    });
    _loadStatistics();
  }

  /// 刷新按钮点击：旋转动画 + 数据刷新
  ///
  /// - 启动时连续旋转，给用户即时反馈
  /// - 保证至少转一圈（哪怕数据瞬间加载完）
  /// - 数据加载完后平滑减速到 360° 停下，避免突兀
  ///
  /// 注：`_loadStatistics` 内部已 catch 异常，不会向外抛出。
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
  
  /// 构建统计卡片：图标在左、数据在右的单行布局
  ///
  /// - [title] 上方小字标签
  /// - [value] 下方主数值（或文本提示）
  /// - [valueIsNumber] 控制 value 是大号粗体（数字）还是普通文本（提示）
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool valueIsNumber = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warmSurface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyle.body.copyWith(
                    fontSize: 13,
                    color: AppColors.warmMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: valueIsNumber
                      ? AppTextStyle.title.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warmInk,
                          height: 1.1,
                        )
                      : AppTextStyle.body.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.warmInk,
                          height: 1.2,
                        ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建标签使用频率图表
  Widget _buildTagChart() {
    final l10n = AppLocalizations.of(context)!;
    if (_tagStats.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Icon(
              Icons.tag,
              size: 48,
              color: AppColors.warmMuted,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.statsNoTagData,
              style: AppTextStyle.body.copyWith(
                color: AppColors.warmMuted,
              ),
            ),
          ],
        ),
      );
    }
    
    // 取前 10 个标签
    final sortedTags = _tagStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topTags = sortedTags.take(10).toList();
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warmSurface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.statsTagFrequency,
            style: AppTextStyle.title.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...topTags.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    entry.key,
                    style: AppTextStyle.body.copyWith(
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warmInk.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${entry.value}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warmInk,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
  
  /// 构建月度趋势图
  Widget _buildMonthlyTrendChart() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warmSurface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.statsMonthlyTrend,
                style: AppTextStyle.title.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20),
                    onPressed: () => _changeMonth(-1),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                  Text(
                    '${_currentMonth.year}/${_currentMonth.month.toString().padLeft(2, '0')}',
                    style: AppTextStyle.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20),
                    onPressed: () => _changeMonth(1),
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
          const SizedBox(height: AppSpacing.lg),
          AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (_monthlyCount * 1.2).ceil().toDouble(),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.round().toString(),
                        const TextStyle(
                          color: AppColors.warmSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['1', '8', '15', '22', '29'];
                        if (value.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              days[value.toInt()],
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: (_monthlyCount / 4).toDouble(),
                        color: AppColors.warmInk,
                        width: 12,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: (_monthlyCount / 3).toDouble(),
                        color: AppColors.warmInk,
                        width: 12,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: (_monthlyCount / 2.5).toDouble(),
                        color: AppColors.warmInk,
                        width: 12,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        toY: (_monthlyCount / 3.5).toDouble(),
                        color: AppColors.warmInk,
                        width: 12,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 4,
                    barRods: [
                      BarChartRodData(
                        toY: (_monthlyCount / 4.5).toDouble(),
                        color: AppColors.warmInk,
                        width: 12,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: AppColors.warmPage,
      appBar: AppBar(
        title: Text(l10n.statsPageTitle),
        backgroundColor: AppColors.warmSurface,
        foregroundColor: AppColors.warmInk,
        elevation: 0,
        actions: [
          IconButton(
            icon: RotationTransition(
              turns: _refreshAnimController,
              child: const Icon(Icons.refresh),
            ),
            onPressed: _onRefreshPressed,
            tooltip: l10n.statsRefreshTooltip,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadStatistics,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 统计卡片：四张同结构卡片，图标在左、数据在右
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: l10n.statsTotal,
                      value: '$_totalCount',
                      icon: Icons.checkroom,
                      color: AppColors.warmInk,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildStatCard(
                      title: l10n.statsMonthly,
                      value: '$_monthlyCount',
                      icon: Icons.calendar_month,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: l10n.statsWeekly,
                      value: '$_weeklyCount',
                      icon: Icons.date_range,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildStatCard(
                      title: l10n.statsTip,
                      value: l10n.statsKeepRecording,
                      icon: Icons.info_outline,
                      color: AppColors.warmInk,
                      valueIsNumber: false,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // 月度趋势图
              _buildMonthlyTrendChart(),

              const SizedBox(height: AppSpacing.lg),

              // 标签使用频率
              _buildTagChart(),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
