import 'dart:io';
import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../models/outfit.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_tokens.dart';
import '../services/image_service.dart';

/// 瀑布流穿搭卡片
///
/// 温暖有机风格：圆角 22px、暖色阴影、图片日期角标叠加、pill 标签
class WaterfallOutfitCard extends StatelessWidget {
  final Outfit outfit;
  final VoidCallback? onTap;

  const WaterfallOutfitCard({
    super.key,
    required this.outfit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tt = context.tt;
    final now = DateTime.now();
    final dateOnly = DateTime(outfit.date.year, outfit.date.month, outfit.date.day);
    final todayOnly = DateTime(now.year, now.month, now.day);
    final dateLabel = dateOnly == todayOnly
        ? l10n.today
        : '${outfit.date.month}/${outfit.date.day}';
    final surface = tt.surface;
    final ink = tt.ink;
    final muted = tt.muted;
    final mist = tt.mist;

    Widget card = Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A554230),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 图片 + 日期角标叠加
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Stack(
              children: [
                Positioned.fill(child: _buildImage(context)),
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: surface.withAlpha(194),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      dateLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: ink,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // 穿搭描述
          Text(
            outfit.description,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: ink,
              height: 1.35,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // pill 标签
          if (outfit.tags.isNotEmpty) ...[
            const SizedBox(height: 7),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: outfit.tags.take(3).map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  decoration: BoxDecoration(
                    color: mist,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: muted,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }

  Widget _buildImage(BuildContext context) {
    final placeholder = _Placeholder(mist: context.tt.mist, muted: context.tt.muted);

    if (outfit.photoPaths.isEmpty) return placeholder;

    return FutureBuilder<File?>(
      future: ImageService.instance.getImageFile(outfit.photoPaths.first),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder;
        }
        final file = snapshot.data;
        if (file == null || !file.existsSync()) return placeholder;

        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.file(
            file,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (ctx, _, _) => _Placeholder(mist: ctx.tt.mist, muted: ctx.tt.muted),
          ),
        );
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  final Color mist;
  final Color muted;
  const _Placeholder({required this.mist, required this.muted});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        color: mist,
        child: Center(child: Icon(Icons.checkroom_outlined, size: 32, color: muted)),
      ),
    );
  }
}
