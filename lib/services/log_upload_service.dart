import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../api/gfs_uploader.dart';
import '../api/log_api.dart';
import 'locale_service.dart';
import 'log_service.dart';

/// 日志上传服务
///
/// 流程：flush 日志 → gzip 压缩到临时文件 → 取直传策略 → GFS 直传拿 file_id
/// → 上报归属与设备信息。任何一步失败抛出异常由 UI 层提示，临时文件始终清理。
class LogUploadService {
  LogUploadService._();
  static final LogUploadService instance = LogUploadService._();

  final LogApi _api = LogApi();

  /// 上传一个日志文件（`app_YYYY-MM-DD.log`），返回服务端记录 id。
  Future<int> upload(File logFile, {String remark = ''}) async {
    // 当日文件可能还有未落盘的写入
    await LogService.instance.flush();

    final logDate = _dateOf(logFile);
    final tmpDir = await getTemporaryDirectory();
    final gzFile = File(
        '${tmpDir.path}${Platform.pathSeparator}app_$logDate.log.gz');
    try {
      final bytes = await logFile.readAsBytes();
      await gzFile.writeAsBytes(gzip.encode(bytes), flush: true);

      final policy = await _api.uploadToken();
      final fileId = await GfsUploader.instance.upload(gzFile, policy);

      final id = await _api.report(
        fileId: fileId,
        logDate: logDate,
        fileSize: await gzFile.length(),
        platform: Platform.operatingSystem,
        platformVersion: Platform.operatingSystemVersion,
        deviceModel: await _deviceModel(),
        appVersion: (await PackageInfo.fromPlatform()).version,
        locale: LocaleService.apiLanguageTag,
        timezone: _timezone(),
        remark: remark,
      );
      LogService.instance.info('LogUpload', 'log $logDate uploaded, record=$id');
      return id;
    } catch (e) {
      LogService.instance.error('LogUpload', 'log $logDate upload failed', e);
      rethrow;
    } finally {
      try {
        if (await gzFile.exists()) await gzFile.delete();
      } catch (_) {
        // 临时文件清理失败不影响结果
      }
    }
  }

  /// 从文件名 `app_YYYY-MM-DD.log` 提取日期
  String _dateOf(File f) {
    final name = f.uri.pathSegments.last;
    final m = RegExp(r'(\d{4}-\d{2}-\d{2})').firstMatch(name);
    return m?.group(1) ?? '';
  }

  /// 设备型号（失败返回空串，不阻断上传）
  Future<String> _deviceModel() async {
    try {
      final plugin = DeviceInfoPlugin();
      if (Platform.isIOS) {
        final info = await plugin.iosInfo;
        return info.utsname.machine; // 如 iPhone15,2
      }
      if (Platform.isAndroid) {
        final info = await plugin.androidInfo;
        return '${info.manufacturer} ${info.model}';
      }
      if (Platform.isMacOS) {
        final info = await plugin.macOsInfo;
        return info.model;
      }
    } catch (_) {
      // 拿不到型号不影响上传
    }
    return '';
  }

  /// 时区：`Asia/Shanghai (+08:00)` 风格（名称由平台提供，可能是缩写）
  String _timezone() {
    final now = DateTime.now();
    final offset = now.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final h = offset.inHours.abs().toString().padLeft(2, '0');
    final m = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    return '${now.timeZoneName} ($sign$h:$m)';
  }
}
