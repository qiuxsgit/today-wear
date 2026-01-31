import 'dart:io';
import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../models/outfit.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import '../theme/tag_colors.dart';
import '../services/image_service.dart';
import '../database/database.dart';
import '../repositories/outfit_repository.dart';

/// 穿搭详情页
///
/// 显示穿搭基本信息，支持删除记录
class OutfitDetailPage extends StatelessWidget {
  /// 穿搭数据
  final Outfit outfit;

  const OutfitDetailPage({
    super.key,
    required this.outfit,
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
      return l10n.dateFormat(date.month, date.day);
    }
  }
  
  /// 执行删除：弹窗确认后删除并返回
  Future<void> _onDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteOutfitConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (context.mounted && confirmed == true) {
      final repository = OutfitRepository(AppDatabase());
      final ok = await repository.permanentlyDeleteOutfit(outfit.id);
      if (context.mounted) {
        Navigator.pop(context, ok);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateText = _formatDate(context, outfit.date);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text(dateText, style: AppTextStyle.title),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        scrolledUnderElevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _onDelete(context),
            tooltip: l10n.delete,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 图片展示
              if (outfit.photoPaths.isNotEmpty)
                _buildImageGallery(outfit.photoPaths)
              else
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: AppColors.imagePlaceholder,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 64,
                      color: AppColors.textPlaceholder,
                    ),
                  ),
                ),
              
              const SizedBox(height: AppSpacing.lg),
              
              // 描述
              Text(
                outfit.description,
                style: AppTextStyle.title,
              ),
              
              // 标签（带颜色）
              if (outfit.tags.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: List.generate(outfit.tags.length, (i) {
                    final tagName = outfit.tags[i];
                    final colorHex = i < outfit.tagColors.length
                        ? outfit.tagColors[i]
                        : TagColors.defaultColorHex;
                    final bgColor = TagColors.fromHex(colorHex);
                    return Chip(
                      label: Text(
                        tagName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      backgroundColor: bgColor,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    );
                  }),
                ),
              ],
              
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建图片画廊
  Widget _buildImageGallery(List<String> photoPaths) {
    if (photoPaths.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 300,
      child: PageView.builder(
        itemCount: photoPaths.length,
        itemBuilder: (context, index) {
          return FutureBuilder<File?>(
            future: ImageService.instance.getImageFile(photoPaths[index]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.imagePlaceholder,
                    borderRadius: BorderRadius.circular(12),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 64,
                      color: AppColors.textPlaceholder,
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    file,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.imagePlaceholder,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 64,
                            color: AppColors.textPlaceholder,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
