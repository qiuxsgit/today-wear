import 'dart:io';

import 'package:flutter/material.dart';

import '../models/outfit.dart';
import '../services/image_download_service.dart';
import '../services/image_service.dart';
import '../theme/app_theme_tokens.dart';

/// 按 [OutfitPhoto] 显示穿搭图片
///
/// 状态机：
/// - 本地文件存在 → 直接 Image.file 显示（零开销）；
/// - 仅有云端图片 id → 首次展示时经 [ImageDownloadService] 懒加载下载，
///   下载中显示加载占位，失败显示占位图 + 重试图标（点击重试）；
/// - 两者皆无 → 静默占位图。
class OutfitImage extends StatefulWidget {
  final OutfitPhoto photo;
  final BoxFit fit;
  final double? width;
  final double? height;

  const OutfitImage({
    super.key,
    required this.photo,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  State<OutfitImage> createState() => _OutfitImageState();
}

class _OutfitImageState extends State<OutfitImage> {
  late Future<File?> _fileFuture;

  @override
  void initState() {
    super.initState();
    _fileFuture = _resolve();
  }

  @override
  void didUpdateWidget(OutfitImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photo.localPath != widget.photo.localPath ||
        oldWidget.photo.serverImageId != widget.photo.serverImageId) {
      _fileFuture = _resolve();
    }
  }

  /// 本地文件优先；缺失且有云端 id 时走懒加载下载
  Future<File?> _resolve() async {
    final path = widget.photo.localPath;
    if (path != null) {
      final file = await ImageService.instance.getImageFile(path);
      if (file != null) return file;
    }
    final id = widget.photo.serverImageId;
    if (id != null) {
      return await ImageDownloadService.instance.ensureDownloaded(id);
    }
    return null;
  }

  void _retry() {
    setState(() => _fileFuture = _resolve());
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    return FutureBuilder<File?>(
      future: _fileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _box(
            tt,
            child: const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final file = snapshot.data;
        if (file != null) {
          return Image.file(
            file,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            errorBuilder: (ctx, _, _) => _failedPlaceholder(ctx.tt),
          );
        }

        // 加载失败：可重试（有云端 id）时点击重试，否则静默占位
        if (widget.photo.serverImageId != null) {
          return GestureDetector(
            onTap: _retry,
            child: _failedPlaceholder(tt),
          );
        }
        return _box(
          tt,
          child: Center(
            child: Icon(Icons.checkroom_outlined, size: 28, color: tt.muted),
          ),
        );
      },
    );
  }

  Widget _failedPlaceholder(AppThemeTokens tt) {
    return _box(
      tt,
      child: Center(
        child: Icon(Icons.refresh_rounded, size: 28, color: tt.muted),
      ),
    );
  }

  Widget _box(AppThemeTokens tt, {required Widget child}) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: tt.mist,
      child: child,
    );
  }
}
