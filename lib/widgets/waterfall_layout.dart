import 'package:flutter/material.dart';

/// 瀑布流布局组件
/// 
/// 实现2列瀑布流布局，自动将子元素分配到较短的列
/// 使用StatefulWidget来动态测量和分配子元素
class WaterfallLayout extends StatefulWidget {
  /// 子元素列表
  final List<Widget> children;
  
  /// 列数（默认2列）
  final int crossAxisCount;
  
  /// 列间距
  final double crossAxisSpacing;
  
  /// 行间距
  final double mainAxisSpacing;
  
  /// 水平内边距
  final double horizontalPadding;
  
  const WaterfallLayout({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 10.0,
    this.mainAxisSpacing = 15.0,
    this.horizontalPadding = 16.0,
  });
  
  @override
  State<WaterfallLayout> createState() => _WaterfallLayoutState();
}

class _WaterfallLayoutState extends State<WaterfallLayout> {
  final List<GlobalKey> _itemKeys = [];
  final List<double> _itemHeights = [];
  List<List<int>> _columnItems = [];
  bool _measured = false;
  
  @override
  void initState() {
    super.initState();
    _itemKeys = List.generate(widget.children.length, (index) => GlobalKey());
    _itemHeights = List.filled(widget.children.length, 0.0);
    _distributeItems();
  }
  
  @override
  void didUpdateWidget(WaterfallLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      _itemKeys.clear();
      _itemKeys.addAll(List.generate(widget.children.length, (index) => GlobalKey()));
      _itemHeights.clear();
      _itemHeights.addAll(List.filled(widget.children.length, 0.0));
      _measured = false;
      _distributeItems();
    }
  }
  
  void _distributeItems() {
    // 初始化列
    _columnItems = List.generate(widget.crossAxisCount, (index) => []);
    final columnHeights = List.filled(widget.crossAxisCount, 0.0);
    
    // 简单策略：交替分配到两列（对于动态高度，实际应该测量后分配）
    // 这里先使用交替分配，然后在post-frame回调中重新测量和分配
    for (int i = 0; i < widget.children.length; i++) {
      // 找到最短的列
      int shortestColumnIndex = 0;
      for (int j = 1; j < widget.crossAxisCount; j++) {
        if (columnHeights[j] < columnHeights[shortestColumnIndex]) {
          shortestColumnIndex = j;
        }
      }
      
      _columnItems[shortestColumnIndex].add(i);
      // 估算高度（假设每个卡片大约200-300高度）
      columnHeights[shortestColumnIndex] += 250.0 + widget.mainAxisSpacing;
    }
  }
  
  void _measureItems() {
    if (_measured) return;
    
    bool allMeasured = true;
    for (int i = 0; i < _itemKeys.length; i++) {
      final key = _itemKeys[i];
      final context = key.currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          _itemHeights[i] = renderBox.size.height;
        } else {
          allMeasured = false;
        }
      } else {
        allMeasured = false;
      }
    }
    
    if (allMeasured) {
      _measured = true;
      // 重新分配基于实际高度
      _redistributeItems();
    }
  }
  
  void _redistributeItems() {
    _columnItems = List.generate(widget.crossAxisCount, (index) => []);
    final columnHeights = List.filled(widget.crossAxisCount, 0.0);
    
    for (int i = 0; i < widget.children.length; i++) {
      int shortestColumnIndex = 0;
      for (int j = 1; j < widget.crossAxisCount; j++) {
        if (columnHeights[j] < columnHeights[shortestColumnIndex]) {
          shortestColumnIndex = j;
        }
      }
      
      _columnItems[shortestColumnIndex].add(i);
      columnHeights[shortestColumnIndex] += _itemHeights[i] + widget.mainAxisSpacing;
    }
    
    if (mounted) {
      setState(() {});
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // 在下一帧测量
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureItems();
    });
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.crossAxisCount, (columnIndex) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: columnIndex < widget.crossAxisCount - 1 
                    ? widget.crossAxisSpacing 
                    : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  _columnItems[columnIndex].length,
                  (itemIndex) {
                    final childIndex = _columnItems[columnIndex][itemIndex];
                    final isLast = itemIndex == _columnItems[columnIndex].length - 1;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: isLast ? 0 : widget.mainAxisSpacing,
                      ),
                      child: Container(
                        key: _itemKeys[childIndex],
                        child: widget.children[childIndex],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
