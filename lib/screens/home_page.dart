import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../models/outfit.dart';
import '../theme/app_spacing.dart';
import '../widgets/waterfall_outfit_card.dart';
import '../widgets/home_topbar.dart';
import '../theme/app_theme_tokens.dart';
import '../database/database.dart';
import '../repositories/outfit_repository.dart';
import '../services/sync_service.dart';
import '../widgets/app_toast.dart';
import '../widgets/sync_error_text.dart';
import '../widgets/home_weather_card.dart';
import 'outfit_detail_page.dart';

const double _listCardSpacing = 20.0;

/// 首页 — 瀑布流穿搭相簿
class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onAddFirstOutfit});

  final VoidCallback? onAddFirstOutfit;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<Outfit> _loadedOutfits = [];
  bool _isLoading = false;
  bool _hasMore = true;
  static const int _pageSize = 10;
  final ScrollController _scrollController = ScrollController();
  late final OutfitRepository _repository;

  /// 当前标签筛选（null 表示"全部"）
  String? _activeTag;

  /// 递增令牌驱动 HomeFilterChips 重载标签
  int _chipsReloadToken = 0;

  @override
  void initState() {
    super.initState();
    _repository = OutfitRepository(AppDatabase());
    _loadMoreData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void refreshData() {
    setState(() {
      _loadedOutfits.clear();
      _hasMore = true;
      _isLoading = false;
      _chipsReloadToken++;
    });
    _loadMoreData();
  }

  /// 下拉刷新：先完整同步（未登录/未开同步/同步中时 syncNow 直接返回），再重载本地数据。
  /// 同步失败用 toast 提示（下拉是显式动作，静默收起会显得"假成功"）。
  Future<void> _onRefresh() async {
    final sync = SyncService.instance;
    await sync.syncNow();
    if (!mounted) return;
    if (sync.status == SyncStatus.error) {
      final l10n = AppLocalizations.of(context)!;
      AppToast.warning(syncErrorText(sync.lastError, sync.lastErrorMessage, l10n));
    }
    // refreshData 是 void：指示器先收起、内容稍后到位；
    // _loadMoreData 有 _isLoading 过渡态保护，本地 SQLite 延迟极短，可接受。
    refreshData();
  }

  void _onFilterChanged(String? tagName) {
    if (tagName == _activeTag) return;
    _activeTag = tagName;
    refreshData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);
    try {
      final activeTag = _activeTag;
      final newOutfits = activeTag == null
          ? await _repository.getAllOutfits(
              limit: _pageSize,
              offset: _loadedOutfits.length,
            )
          : await _repository.getOutfitsByTag(
              activeTag,
              limit: _pageSize,
              offset: _loadedOutfits.length,
            );
      if (!mounted) return;
      setState(() {
        if (newOutfits.isEmpty) {
          _hasMore = false;
        } else {
          _loadedOutfits.addAll(newOutfits);
          _hasMore = newOutfits.length == _pageSize;
        }
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  List<Widget> _buildMasonryContent() {
    if (_loadedOutfits.isEmpty) return [];
    final left = <Widget>[];
    final right = <Widget>[];
    for (int i = 0; i < _loadedOutfits.length; i++) {
      final outfit = _loadedOutfits[i];
      final col = i.isEven ? left : right;
      col.add(
        Padding(
          padding: const EdgeInsets.only(bottom: _listCardSpacing),
          child: WaterfallOutfitCard(
            outfit: outfit,
            onTap: () async {
              final deleted = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => OutfitDetailPage(
                    outfit: outfit,
                    onOutfitChanged: refreshData,
                  ),
                ),
              );
              if (deleted == true && mounted) refreshData();
            },
          ),
        ),
      );
    }
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: left)),
          const SizedBox(width: _listCardSpacing / 2),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: right)),
        ],
      ),
    ];
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    final tt = context.tt;
    return Scaffold(
      backgroundColor: tt.page,
      body: SafeArea(
        child: Column(
          children: [
            HomeTopBar(onAdd: widget.onAddFirstOutfit),
            HomeWeatherCard(tt: tt),
            HomeFilterChips(
              activeTag: _activeTag,
              onFilterChanged: _onFilterChanged,
              reloadToken: _chipsReloadToken,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.checkroom_outlined, size: 64,
                                  color: tt.muted.withValues(alpha: 0.5)),
                              const SizedBox(height: 24),
                              Text(l10n.homeEmptyMessage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: tt.muted, height: 1.5)),
                              const SizedBox(height: 32),
                              FilledButton.icon(
                                onPressed: widget.onAddFirstOutfit,
                                icon: const Icon(Icons.add, size: 20),
                                label: Text(l10n.homeAddFirstOutfit),
                                style: FilledButton.styleFrom(
                                  backgroundColor: tt.ink,
                                  foregroundColor: tt.surface,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildMasonryContent();

    if (content.isEmpty && _isLoading) {
      final tt = context.tt;
      return Scaffold(
        backgroundColor: tt.page,
        body: SafeArea(
          child: Column(
            children: [
              HomeTopBar(onAdd: widget.onAddFirstOutfit),
              HomeWeatherCard(tt: tt),
              HomeFilterChips(
                activeTag: _activeTag,
                onFilterChanged: _onFilterChanged,
                reloadToken: _chipsReloadToken,
              ),
              const Expanded(child: Center(child: CircularProgressIndicator())),
            ],
          ),
        ),
      );
    }

    if (content.isEmpty) return _buildEmptyState();

    final tt = context.tt;
    return Scaffold(
      backgroundColor: tt.page,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HomeTopBar(onAdd: widget.onAddFirstOutfit),
            HomeWeatherCard(tt: tt),
            HomeFilterChips(
              activeTag: _activeTag,
              onFilterChanged: _onFilterChanged,
              reloadToken: _chipsReloadToken,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    top: 4,
                    bottom: 96,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...content,
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Center(child: CircularProgressIndicator()),
                        ),
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
}
