import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../models/outfit.dart';
import '../theme/app_colors.dart';

/// 时间轴穿搭卡片组件
/// 
/// 用于时间轴布局的紧凑卡片，符合设计规范：
/// - 宽度：150（固定）
/// - 高度：200（固定）
/// - 圆角：12
/// - 白色背景
/// - 内边距：12
class TimelineOutfitCard extends StatelessWidget {
  /// 穿搭数据
  final Outfit outfit;
  
  /// 点击回调
  final VoidCallback? onTap;
  
  const TimelineOutfitCard({
    super.key,
    required this.outfit,
    this.onTap,
  });
  
  /// 格式化日期显示
  String _formatDate(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly == today) {
      return l10n.today;
    } else if (dateOnly == today.subtract(const Duration(days: 1))) {
      return l10n.yesterday;
    } else {
      // 使用中文格式：1月26日
      return l10n.dateFormat(date.month, date.day);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final dateText = _formatDate(context, outfit.date);
    
    Widget cardContent = Container(
      width: 150,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 日期文本
          Text(
            dateText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 图片占位符
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.imagePlaceholder,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 32,
                  color: AppColors.textPlaceholder,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 描述文本
          Text(
            outfit.description,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
    
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardContent,
      );
    }
    
    return cardContent;
  }
}
