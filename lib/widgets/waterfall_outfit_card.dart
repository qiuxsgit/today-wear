import 'dart:io';
import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../models/outfit.dart';
import '../theme/app_colors.dart';
import '../services/image_service.dart';

/// 瀑布流穿搭卡片组件
///
/// 用于两列布局的穿搭卡片，符合设计规范：
/// - 圆角 16，白色背景
/// - 图片比例 4:5，圆角裁剪
/// - 今天卡片视觉权重更高（primary 日期标签、略强阴影、图片区略大）
/// - 过去日期使用灰色系统、轻阴影
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

  /// 是否为「今天」的穿搭
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    return dateOnly == today;
  }

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
      return l10n.dateFormat(date.month, date.day);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _formatDate(context, outfit.date);
    final isToday = _isToday(outfit.date);

    // 今天：略强阴影；过去：轻阴影
    final shadowColor = Colors.black.withValues(alpha: isToday ? 0.08 : 0.04);

    Widget cardContent = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: isToday ? 12 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 日期标签：今天用 primary 低透明背景，过去用灰色
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isToday
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : AppColors.bgTertiary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dateText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isToday
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 图片区域：4:5 比例，今天略高 +10px
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = (w * (5 / 4)) + (isToday ? 10.0 : 0.0);
              return SizedBox(
                width: w,
                height: h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildImage(),
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          // 主描述：text-primary
          Text(
            outfit.description,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // 标签行（轻量）：#标签，text-secondary
          if (outfit.tags.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              outfit.tags.map((t) => '#$t').join('  '),
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
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

  /// 构建图片 widget（由外层 ClipRRect 裁剪圆角，此处填满容器）
  Widget _buildImage() {
    if (outfit.photoPaths.isEmpty) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.imagePlaceholder,
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

    return FutureBuilder<File?>(
      future: ImageService.instance.getImageFile(outfit.photoPaths.first),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.imagePlaceholder,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final file = snapshot.data;
        if (file == null || !file.existsSync()) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.imagePlaceholder,
            child: const Center(
              child: Icon(
                Icons.image,
                size: 32,
                color: AppColors.textPlaceholder,
              ),
            ),
          );
        }

        return Image.file(
          file,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColors.imagePlaceholder,
              child: const Center(
                child: Icon(
                  Icons.broken_image,
                  size: 32,
                  color: AppColors.textPlaceholder,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
