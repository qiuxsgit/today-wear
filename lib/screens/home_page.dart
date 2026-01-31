import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../models/outfit.dart';
import '../theme/app_colors.dart';
import '../widgets/waterfall_outfit_card.dart';
import '../database/database.dart';
import '../repositories/outfit_repository.dart';
import 'outfit_detail_page.dart';

/// 首页
/// 
/// 展示瀑布流布局的穿搭记录，按日期分组
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.onAddFirstOutfit,
  });

  /// 无数据时用户点击「添加第一条穿搭」的回调，通常用于切换到添加页
  final VoidCallback? onAddFirstOutfit;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  /// 当前加载的数据
  List<Outfit> _loadedOutfits = [];
  
  /// 是否正在加载
  bool _isLoading = false;
  
  /// 是否还有更多数据
  bool _hasMore = true;
  
  /// 每页加载数量
  static const int _pageSize = 10;
  
  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();
  
  /// 数据库仓库
  late final OutfitRepository _repository;
  
  @override
  void initState() {
    super.initState();
    _initializeRepository();
    _loadMoreData();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  /// 初始化仓库
  void _initializeRepository() {
    // 从全局获取数据库实例（需要在 main.dart 中初始化）
    final db = AppDatabase();
    _repository = OutfitRepository(db);
  }
  
  /// 刷新数据（从第一页重新加载）
  void refreshData() {
    setState(() {
      _loadedOutfits.clear();
      _hasMore = true;
      _isLoading = false;
    });
    _loadMoreData();
  }
  
  /// 滚动监听，实现加载更多
  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }
  
  /// 加载更多数据
  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMore) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final offset = _loadedOutfits.length;
      final newOutfits = await _repository.getAllOutfits(
        limit: _pageSize,
        offset: offset,
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
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }
  
  /// 构建两列瀑布流内容
  List<Widget> _buildGroupedContent() {
    if (_loadedOutfits.isEmpty) {
      return [];
    }

    // 左右两列
    final leftColumnWidgets = <Widget>[];
    final rightColumnWidgets = <Widget>[];

    // 按顺序分配到两列
    for (int i = 0; i < _loadedOutfits.length; i++) {
      final outfit = _loadedOutfits[i];
      final targetColumn = i % 2 == 0 ? leftColumnWidgets : rightColumnWidgets;

      targetColumn.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: WaterfallOutfitCard(
            outfit: outfit,
            onTap: () async {
              final deleted = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => OutfitDetailPage(outfit: outfit),
                ),
              );
              if (deleted == true && mounted) {
                refreshData();
              }
            },
          ),
        ),
      );
    }

    // 创建最终的两列布局
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: leftColumnWidgets,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rightColumnWidgets,
            ),
          ),
        ],
      )
    ];
  }
  
  /// 构建空状态：无穿搭记录时的友好提示
  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.checkroom_outlined,
                  size: 64,
                  color: AppColors.textPlaceholder,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.homeEmptyMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: widget.onAddFirstOutfit,
                  icon: const Icon(Icons.add, size: 20),
                  label: Text(l10n.homeAddFirstOutfit),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildGroupedContent();

    // 正在加载且尚无任何数据：显示转圈
    if (content.isEmpty && _isLoading) {
      return Scaffold(
        backgroundColor: AppColors.bgSecondary,
        body: const SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // 已加载完成但没有数据：显示空状态提示
    if (content.isEmpty) {
      return _buildEmptyState();
    }

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...content,
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              // 底部留白，不压住导航栏
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

