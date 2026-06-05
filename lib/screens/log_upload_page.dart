import 'dart:io';

import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';

import '../services/log_service.dart';
import '../services/log_upload_service.dart';
import '../services/session_service.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_tokens.dart';
import '../widgets/app_toast.dart';

/// 日志上传页面
///
/// 列出本地日志文件（按日期倒序），点击某一行确认后 gzip 压缩直传 GFS，
/// 并上报归属与设备信息，用于客户端问题排查。需登录（不要求订阅）。
class LogUploadPage extends StatefulWidget {
  const LogUploadPage({super.key});

  @override
  State<LogUploadPage> createState() => _LogUploadPageState();
}

class _LogUploadPageState extends State<LogUploadPage> {
  List<({File file, String date, int size})> _files = const [];
  bool _loading = true;

  /// 正在上传的文件路径（同一时刻只允许一个上传）
  String? _uploadingPath;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final files = await LogService.instance.listLogFiles();
    final items = <({File file, String date, int size})>[];
    for (final f in files) {
      final m = RegExp(r'(\d{4}-\d{2}-\d{2})').firstMatch(f.uri.pathSegments.last);
      int size = 0;
      try {
        size = await f.length();
      } catch (_) {
        // 文件可能刚被清理，跳过大小展示
      }
      items.add((file: f, date: m?.group(1) ?? '', size: size));
    }
    if (!mounted) return;
    setState(() {
      _files = items;
      _loading = false;
    });
  }

  String _formatSize(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    if (bytes >= 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '$bytes B';
  }

  Future<void> _onTapFile(({File file, String date, int size}) item) async {
    final l10n = AppLocalizations.of(context)!;
    if (_uploadingPath != null) return;
    if (!SessionService.instance.isLoggedIn) {
      AppToast.warning(l10n.logUploadLoginRequired);
      return;
    }

    final remark = await _askRemark(item.date);
    if (remark == null || !mounted) return; // 取消

    setState(() => _uploadingPath = item.file.path);
    try {
      await LogUploadService.instance.upload(item.file, remark: remark);
      if (mounted) AppToast.success(l10n.logUploadSuccess);
    } catch (_) {
      if (mounted) AppToast.error(l10n.logUploadFailed);
    } finally {
      if (mounted) setState(() => _uploadingPath = null);
    }
  }

  /// 确认弹窗（含可选备注输入框）。返回 null 表示取消，否则为备注文本。
  Future<String?> _askRemark(String date) {
    final l10n = AppLocalizations.of(context)!;
    final tt = context.tt;
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: tt.surface,
        title: Text('${l10n.logUploadConfirmTitle} · $date',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: tt.ink)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.logUploadConfirmMessage,
                style: TextStyle(fontSize: 14, color: tt.muted)),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: controller,
              maxLines: 3,
              maxLength: 500,
              style: TextStyle(fontSize: 14, color: tt.ink),
              decoration: InputDecoration(
                hintText: l10n.logUploadRemarkHint,
                hintStyle: TextStyle(fontSize: 13, color: tt.muted),
                filled: true,
                fillColor: tt.mist,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel, style: TextStyle(color: tt.muted)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: tt.ink),
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(l10n.logUploadAction),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tt = context.tt;

    return Scaffold(
      backgroundColor: tt.page,
      appBar: AppBar(
        title: Text(l10n.logUpload),
        backgroundColor: tt.surface,
        foregroundColor: tt.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        scrolledUnderElevation: 2,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _files.isEmpty
              ? Center(
                  child: Text(l10n.logUploadEmpty,
                      style: TextStyle(fontSize: 14, color: tt.muted)),
                )
              : ListView.separated(
                  padding: EdgeInsets.only(
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    top: AppSpacing.md,
                    bottom: 72 + MediaQuery.of(context).padding.bottom,
                  ),
                  itemCount: _files.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final item = _files[index];
                    final uploading = _uploadingPath == item.file.path;
                    return Container(
                      decoration: BoxDecoration(
                        color: tt.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: Icon(Icons.description_outlined, color: tt.muted),
                        title: Text(item.date,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: tt.ink)),
                        subtitle: Text(_formatSize(item.size),
                            style: TextStyle(fontSize: 12, color: tt.muted)),
                        trailing: uploading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(Icons.cloud_upload_outlined, color: tt.muted),
                        onTap: () => _onTapFile(item),
                      ),
                    );
                  },
                ),
    );
  }
}
