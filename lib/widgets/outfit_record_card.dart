import 'dart:io';
import 'package:flutter/material.dart';
import '../models/outfit.dart';
import '../services/image_service.dart';
import '../theme/app_colors.dart';

/// 穿搭记录卡片
///
/// 信息层级：
/// - 左侧 72×72 封面图（圆角 12，自动从 ImageService 解析相对路径）
/// - 标题：描述（加粗）
/// - 副信息：时间 + 图片数量
/// - 标签胶囊（最多 4 个）
/// - 右侧 chevron 提示可点击
class OutfitRecordCard extends StatelessWidget {
  final Outfit outfit;
  final VoidCallback onTap;

  const OutfitRecordCard({
    super.key,
    required this.outfit,
    required this.onTap,
  });

  String get _title =>
      outfit.description.isNotEmpty ? outfit.description : '未填写描述';

  String get _timeLabel {
    final h = outfit.date.hour.toString().padLeft(2, '0');
    final m = outfit.date.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.warmSurface,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.warmSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Cover(
                  path: outfit.photoPaths.isNotEmpty
                      ? outfit.photoPaths.first
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(child: _Info(outfit: outfit, title: _title, time: _timeLabel)),
                const SizedBox(width: 4),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(
                    Icons.chevron_right,
                    color: AppColors.warmMuted,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final Outfit outfit;
  final String title;
  final String time;

  const _Info({required this.outfit, required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.warmInk,
            height: 1.35,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(
              Icons.access_time,
              size: 12,
              color: AppColors.warmMuted,
            ),
            const SizedBox(width: 4),
            Text(
              time,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.warmMuted,
              ),
            ),
            if (outfit.photoPaths.length > 1) ...[
              const SizedBox(width: 10),
              const Icon(
                Icons.photo_library_outlined,
                size: 12,
                color: AppColors.warmMuted,
              ),
              const SizedBox(width: 3),
              Text(
                '${outfit.photoPaths.length}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.warmMuted,
                ),
              ),
            ],
          ],
        ),
        if (outfit.tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: outfit.tags.take(4).map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.warmInk.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.warmInk,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _Cover extends StatelessWidget {
  final String? path;
  const _Cover({this.path});

  static const double _size = 72;
  static const double _radius = 12;

  Widget get _placeholder => Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: AppColors.warmInk.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(_radius),
        ),
        child: const Icon(
          Icons.checkroom,
          color: AppColors.warmInk,
          size: 28,
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (path == null) return _placeholder;
    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: FutureBuilder<File?>(
        future: ImageService.instance.getImageFile(path!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: _size,
              height: _size,
              color: AppColors.warmMist,
            );
          }
          final file = snapshot.data;
          if (file == null || !file.existsSync()) return _placeholder;
          return Image.file(
            file,
            width: _size,
            height: _size,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
