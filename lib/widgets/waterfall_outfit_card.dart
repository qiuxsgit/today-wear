import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../models/outfit.dart';
import '../theme/app_colors.dart';

/// 瀑布流穿搭卡片组件
///
/// 用于瀑布流布局的卡片，符合设计规范：
/// - 宽度：自适应（由父容器决定）
/// - 高度：由内容决定
/// - 圆角：12
/// - 白色背景
/// - 内边距：12
/// - 图片比例：3:4（竖向）
class WaterfallOutfitCard extends StatelessWidget {
  /// 穿搭数据
  final Outfit outfit;

  /// 点击回调
  final VoidCallback? onTap;

  const WaterfallOutfitCard({
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
    } else if (dateOnly == today.subtract(const Duration(days: 2))) {
      return l10n.dayBeforeYesterday;
    } else {
      // 使用中文格式：1月26日
      return l10n.dateFormat(date.month, date.day);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _formatDate(context, outfit.date);

    Widget cardContent = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 日期标签（左上角）
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.bgTertiary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Date.',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPlaceholder,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  dateText,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 图片占位符（3:4比例）
          AspectRatio(
            aspectRatio: 3 / 4,
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
