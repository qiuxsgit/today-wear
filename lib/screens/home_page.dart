import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../models/outfit.dart';
import '../theme/app_spacing.dart';
import '../widgets/waterfall_outfit_card.dart';
import '../widgets/home_topbar.dart';
import '../theme/app_theme_tokens.dart';
import '../database/database.dart';
import '../repositories/outfit_repository.dart';
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
    });
    _loadMoreData();
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
            _WeatherCard(tt: tt),
            HomeFilterChips(activeTag: _activeTag, onFilterChanged: _onFilterChanged),
            Expanded(
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
              _WeatherCard(tt: tt),
              HomeFilterChips(activeTag: _activeTag, onFilterChanged: _onFilterChanged),
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
            _WeatherCard(tt: tt),
            HomeFilterChips(activeTag: _activeTag, onFilterChanged: _onFilterChanged),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
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
          ],
        ),
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final AppThemeTokens tt;
  const _WeatherCard({required this.tt});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-0.77, -0.64),
            end: const Alignment(0.77, 0.64),
            colors: [tt.ink, tt.accent2],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Color(0x12554230), blurRadius: 28, offset: Offset(0, 12))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.weatherPlaceholderLocation,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tt.page.withValues(alpha: 0.8)),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    l10n.weatherPlaceholderAdvice,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: tt.page),
                  ),
                ],
              ),
            ),
            Text(
              '24°',
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.w300, color: tt.page),
            ),
          ],
        ),
      ),
    );
  }
}
