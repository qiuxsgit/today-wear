import 'dart:io';
import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../models/outfit.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../services/image_service.dart';

/// 瀑布流穿搭卡片组件
///
/// 用于瀑布流布局的卡片，符合设计规范：
/// - 宽度：自适应（由父容器决定）
/// - 高度：由内容决定
/// - 圆角：16
/// - 白色背景
/// - 内边距：12（AppSpacing.sm）
/// - 图片比例：3:4（竖向）
/// - 「今天」卡片通过阴影与轻微描边强化视觉权重
class WaterfallOutfitCard extends StatelessWidget {
  /// 穿搭数据
  final Outfit outfit;

  /// 点击回调
  final VoidCallback? onTap;

  /// 是否为「今天」的穿搭（用于强化视觉权重，不传则根据 outfit.date 计算）
  final bool? isToday;

  const WaterfallOutfitCard({
    super.key,
    required this.outfit,
    this.onTap,
    this.isToday,
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

  bool _isToday(BuildContext context) {
    if (isToday != null) return isToday!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(outfit.date.year, outfit.date.month, outfit.date.day);
    return dateOnly == today;
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _formatDate(context, outfit.date);
    final isTodayCard = _isToday(context);

    Widget cardContent = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isTodayCard
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha:0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
        border: isTodayCard
            ? Border.all(color: AppColors.primary.withValues(alpha:0.15), width: 1)
            : null,
      ),
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 日期标签（左上角）
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isTodayCard
                  ? AppColors.primary.withValues(alpha:0.08)
                  : AppColors.bgTertiary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Date.',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isTodayCard
                        ? AppColors.primary.withValues(alpha:0.8)
                        : AppColors.textPlaceholder,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  dateText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isTodayCard
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // 图片（3:4 比例，自然竖向）
          AspectRatio(
            aspectRatio: 3 / 4,
            child: _buildImage(),
          ),

          const SizedBox(height: AppSpacing.xs),

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

  /// 构建图片 widget
  Widget _buildImage() {
    if (outfit.photoPaths.isEmpty) {
      // 没有图片，显示占位符
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.imagePlaceholder,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Icon(
            Icons.image,
            size: 32,
            color: AppColors.textPlaceholder,
          ),
        ),
      );
    }

    // 显示第一张图片
    return FutureBuilder<File?>(
      future: ImageService.instance.getImageFile(outfit.photoPaths.first),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.imagePlaceholder,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final file = snapshot.data;
        if (file == null || !file.existsSync()) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.imagePlaceholder,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                Icons.image,
                size: 32,
                color: AppColors.textPlaceholder,
              ),
            ),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            file,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.imagePlaceholder,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 32,
                    color: AppColors.textPlaceholder,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
