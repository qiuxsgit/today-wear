import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/version_api.dart';
import '../l10n/app_localizations.dart';
import '../services/apk_installer.dart';
import '../services/dist_channel.dart';
import '../services/log_service.dart';
import '../services/update_service.dart';
import '../theme/app_theme_tokens.dart';
import 'app_toast.dart';

/// App Store 应用 ID；iOS 上架后替换为真实数字 ID。
const String _appStoreAppId = '0000000000';

/// 弹出更新提示。强更时不可关闭（无"暂不更新"、点外不消失、拦截返回键）。
Future<void> showUpdateDialog(BuildContext context, VersionCheckResult result) {
  return showDialog<void>(
    context: context,
    barrierDismissible: !result.forceUpdate,
    builder: (_) => UpdateDialog(result: result),
  );
}

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({super.key, required this.result});

  final VersionCheckResult result;

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  bool _downloading = false;
  double _progress = 0;

  Future<void> _onUpdate() async {
    final channel = DistChannel.resolve();
    if (channel == DistChannel.channelPlay) {
      await _openPlayStore();
    } else if (channel == DistChannel.channelAppStore) {
      await _openUrl('https://apps.apple.com/app/id$_appStoreAppId');
    } else if (channel == DistChannel.channelApk) {
      await _downloadAndInstall(widget.result.downloadUrl);
    }
    // 不支持的平台不会弹出本对话框，channel == null 时无操作
  }

  Future<void> _openPlayStore() async {
    final pkg = (await PackageInfo.fromPlatform()).packageName;
    // market:// 优先（直开 Play App），失败回退网页链接
    if (!await _openUrl('market://details?id=$pkg')) {
      await _openUrl('https://play.google.com/store/apps/details?id=$pkg');
    }
  }

  Future<bool> _openUrl(String url) async {
    try {
      return await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication);
    } catch (e) {
      LogService.instance.error('Update', 'launch $url failed', e);
      return false;
    }
  }

  Future<void> _downloadAndInstall(String? url) async {
    // 在第一个 await 前捕获 l10n，规避 use_build_context_synchronously lint
    final l10n = AppLocalizations.of(context)!;
    if (url == null) {
      AppToast.error(l10n.updateDownloadFailed);
      return;
    }
    setState(() {
      _downloading = true;
      _progress = 0;
    });
    try {
      File apk;
      try {
        apk = await ApkInstaller.instance
            .download(url, onProgress: _onProgress);
      } on ApkUrlExpiredException {
        // 签名 URL 过期：重新 check 换新 URL 重试一次
        final fresh = await UpdateService.instance.checkManually();
        final freshUrl = fresh?.downloadUrl;
        if (freshUrl == null) {
          if (mounted) AppToast.error(l10n.updateDownloadFailed);
          return;
        }
        apk = await ApkInstaller.instance
            .download(freshUrl, onProgress: _onProgress);
      }
      await ApkInstaller.instance.install(apk);
    } catch (e) {
      LogService.instance.error('Update', 'download/install failed', e);
      // 强更场景失败不解除阻断：弹窗保持，可再次点击
      if (mounted) AppToast.error(l10n.updateDownloadFailed);
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  void _onProgress(double p) {
    if (mounted) setState(() => _progress = p);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tt = context.tt;
    final r = widget.result;
    return PopScope(
      // 强更拦截系统返回键
      canPop: !r.forceUpdate,
      child: AlertDialog(
        title: Text('${l10n.newVersionFound} ${r.latestVersionName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (r.forceUpdate) ...[
              Text(l10n.forceUpdateNotice,
                  style: TextStyle(fontSize: 13, color: tt.muted)),
              const SizedBox(height: 8),
            ],
            if (r.notes.isNotEmpty)
              Text(r.notes, style: TextStyle(fontSize: 13, color: tt.ink)),
            if (_downloading) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(value: _progress > 0 ? _progress : null),
              const SizedBox(height: 6),
              Text(l10n.updateDownloading,
                  style: TextStyle(fontSize: 12, color: tt.muted)),
            ],
          ],
        ),
        actions: [
          if (!r.forceUpdate)
            TextButton(
              onPressed: _downloading ? null : () => Navigator.pop(context),
              child: Text(l10n.updateLater),
            ),
          TextButton(
            onPressed: _downloading ? null : _onUpdate,
            style: TextButton.styleFrom(foregroundColor: tt.accent),
            child: Text(l10n.updateNow),
          ),
        ],
      ),
    );
  }
}
