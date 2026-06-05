import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../api/api_exception.dart';
import 'log_service.dart';

/// 签名下载 URL 过期（GFS 403），调用方应重新 check 换新 URL 重试。
class ApkUrlExpiredException implements Exception {
  const ApkUrlExpiredException();
}

/// APK 下载与安装（仅 apk 渠道使用）
class ApkInstaller {
  ApkInstaller._();
  static final ApkInstaller instance = ApkInstaller._();

  /// 流式下载 APK 到临时目录，进度回调 0.0~1.0。
  /// 403 抛 [ApkUrlExpiredException]；其他非 200 抛 [ApiException]。
  Future<File> download(String url,
      {void Function(double progress)? onProgress}) async {
    final client = http.Client();
    try {
      final res = await client.send(http.Request('GET', Uri.parse(url)));
      if (res.statusCode == 403) {
        LogService.instance.info('Update', 'apk url expired (403)');
        throw const ApkUrlExpiredException();
      }
      if (res.statusCode != 200) {
        LogService.instance.error('Update', 'apk download -> ${res.statusCode}');
        throw ApiException(status: res.statusCode, code: 'apk_download_failed');
      }
      final dir = await getTemporaryDirectory();
      final file =
          File('${dir.path}${Platform.pathSeparator}today_wear_update.apk');
      final sink = file.openWrite();
      try {
        var received = 0;
        final total = res.contentLength ?? 0;
        await for (final chunk in res.stream) {
          sink.add(chunk);
          received += chunk.length;
          if (total > 0) onProgress?.call(received / total);
        }
      } finally {
        await sink.close();
      }
      LogService.instance.info('Update', 'apk downloaded: ${file.path}');
      return file;
    } finally {
      client.close();
    }
  }

  /// 调起系统安装器（open_filex 自带 FileProvider，无需自配）。
  Future<void> install(File apk) async {
    final result = await OpenFilex.open(apk.path);
    if (result.type != ResultType.done) {
      LogService.instance
          .error('Update', 'open apk failed: ${result.type} ${result.message}');
      throw ApiException(status: 0, code: 'apk_install_failed');
    }
  }
}
