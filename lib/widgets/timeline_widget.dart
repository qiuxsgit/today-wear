import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 时间线组件
/// 
/// 显示垂直时间线，包含：
/// - 灰色垂直线（#CCCCCC，宽度2）
/// - 蓝色圆点标记（#4A90E2，直径8）
class TimelineWidget extends StatelessWidget {
  /// 时间线总高度
  final double height;
  
  /// 时间线位置（x坐标，相对于父容器）
  final double positionX;
  
  /// 圆点位置列表（y坐标，相对于父容器）
  final List<double> dotPositions;
  
  const TimelineWidget({
    super.key,
    required this.height,
    required this.positionX,
    required this.dotPositions,
  });
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 垂直时间线
        Positioned(
          left: positionX - 1, // 居中，减去线宽度的一半
          top: 0,
          child: Container(
            width: 2,
            height: height,
            color: AppColors.timelineLine,
          ),
        ),
        
        // 时间点圆点
        ...dotPositions.map((y) {
          return Positioned(
            left: positionX - 4, // 居中，减去圆点直径的一半
            top: y - 4, // 居中，减去圆点直径的一半
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.timelineDot,
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ],
    );
  }
}
