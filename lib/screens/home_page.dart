import 'package:flutter/material.dart';
import '../models/outfit.dart';
import '../theme/app_colors.dart';
import '../widgets/waterfall_outfit_card.dart';
import 'outfit_detail_page.dart';

/// 首页
/// 
/// 展示瀑布流布局的穿搭记录，按日期分组
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  
  @override
  void initState() {
    super.initState();
    _loadMoreData();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  /// 滚动监听，实现加载更多
  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }
  
  /// 加载更多数据
  void _loadMoreData() {
    if (_isLoading || !_hasMore) return;
    
    setState(() {
      _isLoading = true;
    });
    
    // 模拟异步加载
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      
      final allData = Outfit.generateMockData();
      final currentCount = _loadedOutfits.length;
      final nextCount = (currentCount + _pageSize).clamp(0, allData.length);
      
      setState(() {
        _loadedOutfits = allData.sublist(0, nextCount);
        _hasMore = nextCount < allData.length;
        _isLoading = false;
      });
    });
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
          padding: const EdgeInsets.only(bottom: 10),
          child: WaterfallOutfitCard(
            outfit: outfit,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OutfitDetailPage(outfit: outfit),
                ),
              );
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
          const SizedBox(width: 10),
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
  
  @override
  Widget build(BuildContext context) {
    final content = _buildGroupedContent();
    
    if (content.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.bgSecondary,
        body: const SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...content,
              // 加载更多指示器
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

