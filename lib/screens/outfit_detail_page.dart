import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../models/outfit.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_tokens.dart';
import '../theme/tag_colors.dart';
import '../database/database.dart';
import '../repositories/outfit_repository.dart';
import '../services/image_download_service.dart';
import '../services/sync_service.dart';
import '../services/ver_check_service.dart';
import '../widgets/outfit_image.dart';
import '../widgets/ver_conflict_dialogs.dart';
import 'add_outfit_page.dart';

/// 穿搭详情页
///
/// 显示穿搭基本信息，支持删除和编辑记录
class OutfitDetailPage extends StatefulWidget {
  /// 穿搭数据
  final Outfit outfit;

  /// 数据变更回调（编辑保存或删除后触发，用于通知上一页刷新）
  final VoidCallback? onOutfitChanged;

  const OutfitDetailPage({
    super.key,
    required this.outfit,
    this.onOutfitChanged,
  });

  @override
  State<OutfitDetailPage> createState() => _OutfitDetailPageState();
}

class _OutfitDetailPageState extends State<OutfitDetailPage> {
  late Outfit _outfit;

  /// 渲染 gate：进入详情先做记录级 ver 读校验（1.5s 超时降级），避免编辑旧数据
  bool _checking = true;

  Outfit get outfit => _outfit;

  @override
  void initState() {
    super.initState();
    _outfit = widget.outfit;
    _runVerCheck();
  }

  @override
  void dispose() {
    _pushIfDirty(_outfit.id);
    super.dispose();
  }

  /// 离开详情页：该条有未推送修改则机会性触发同步（fire-and-forget，不依赖 context）
  static void _pushIfDirty(int outfitId) {
    Future(() async {
      final row = await AppDatabase().outfitDao.getOutfitByIdRaw(outfitId);
      if (row != null && row.dirty == 1) {
        SyncService.instance.syncInBackground();
      }
    });
  }

  Future<void> _runVerCheck() async {
    final result = await VerCheckService.instance.checkOutfit(_outfit.id);
    if (!mounted) return;
    switch (result.status) {
      case VerCheckStatus.refreshed:
        await _reloadOutfit();
      case VerCheckStatus.conflict:
        final keepLocal = await showVerConflictDialog(context);
        if (!mounted) return;
        if (keepLocal == true) {
          await VerCheckService.instance.keepLocalOutfit(_outfit.id, result.remote!);
        } else if (keepLocal == false) {
          await VerCheckService.instance.useCloudOutfit(result.remote!);
          await _reloadOutfit();
          widget.onOutfitChanged?.call();
        }
      case VerCheckStatus.remoteDeleted:
        final restore = await showRemoteDeletedDialog(context);
        if (!mounted) return;
        if (restore == true) {
          await VerCheckService.instance.restoreOutfit(_outfit.id, result.remote!);
        } else {
          await VerCheckService.instance.acceptOutfitDeleted(result.remote!);
          widget.onOutfitChanged?.call();
          if (mounted) Navigator.pop(context);
          return;
        }
      case VerCheckStatus.skipped:
      case VerCheckStatus.upToDate:
        break;
    }
    if (!mounted) return;
    setState(() => _checking = false);
    // 进入详情即预下载整条穿搭的全部图片（PageView 只构建可见页，
    // 不预下载的话后面几张要等翻页才开始下，编辑页也拿不到文件）。
    // 放在校验完成后执行，确保下载的是最新图片集合。
    ImageDownloadService.instance.ensureAllDownloaded(_outfit.photos);
  }

  /// 按本地 id 重查并替换展示数据（ver 校验拉到新版本后）
  Future<void> _reloadOutfit() async {
    final fresh = await OutfitRepository(AppDatabase()).getOutfitById(_outfit.id);
    if (fresh != null && mounted) setState(() => _outfit = fresh);
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

  /// 编辑穿搭
  Future<void> _onEdit(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AddOutfitPage(outfit: outfit),
      ),
    );
    if (result == true) {
      widget.onOutfitChanged?.call();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tt = context.tt;

    if (_checking) {
      return Scaffold(
        backgroundColor: tt.page,
        body: const SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    final dateText = _formatDate(context, outfit.date);

    return Scaffold(
      backgroundColor: tt.page,
      appBar: AppBar(
        title: Text(
          dateText,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: tt.ink),
        ),
        backgroundColor: tt.surface,
        foregroundColor: tt.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        scrolledUnderElevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _onEdit(context),
            tooltip: l10n.editOutfitTooltip,
          ),
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
              if (outfit.photos.isNotEmpty)
                _buildImageGallery(context, outfit.photos)
              else
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: tt.mist,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(Icons.image, size: 64, color: tt.muted),
                  ),
                ),

              const SizedBox(height: AppSpacing.lg),

              Text(
                outfit.description,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: tt.ink),
              ),

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
                        style: TextStyle(fontSize: 12, color: tt.muted),
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

  Widget _buildImageGallery(BuildContext context, List<OutfitPhoto> photos) {
    if (photos.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 300,
      child: PageView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: OutfitImage(
                photo: photos[index],
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          );
        },
      ),
    );
  }
}
