import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// 客户端本地日志服务
///
/// - 每天一个文件：`<appSupport>/logs/app_YYYY-MM-DD.log`
/// - 保留 7 天，init 时按文件名日期清理过期文件
/// - 单日 5MB 上限，超限写入标记后停止当日写入
/// - 每条写入后 flush，保证崩溃前的日志不丢
/// - **自身永不抛错**：所有 IO 异常吞掉（最多 debugPrint），不影响 app 运行
class LogService {
  LogService._();
  static final LogService instance = LogService._();

  /// 测试专用构造（绕开单例，配合 [init] 的 directory 注入）
  @visibleForTesting
  LogService.forTesting();

  static const int _retentionDays = 7;

  /// 单日文件大小上限（测试可调小）
  @visibleForTesting
  int maxDailyBytes = 5 * 1024 * 1024;

  /// 当前时间来源（测试可注入以模拟跨天）
  @visibleForTesting
  DateTime Function() now = DateTime.now;

  Directory? _dir;
  IOSink? _sink;
  String _currentDate = '';
  int _currentSize = 0;
  bool _capped = false;

  /// 串行化所有文件操作，避免异步写入交叉
  Future<void> _chain = Future.value();

  /// 初始化：建目录、清理过期文件、打开当日文件。
  /// [directory] 仅测试注入；缺省用系统 application support 目录。
  Future<void> init({Directory? directory}) async {
    try {
      final base = directory ?? await getApplicationSupportDirectory();
      final dir = Directory('${base.path}${Platform.pathSeparator}logs');
      await dir.create(recursive: true);
      _dir = dir;
      await _cleanup(dir);
      await _openFor(_dateString(now()));
    } catch (e) {
      if (kDebugMode) debugPrint('[LogService] init failed: $e');
      _dir = null;
    }
  }

  void info(String tag, String message) => _enqueue('I', tag, message);

  void warn(String tag, String message) => _enqueue('W', tag, message);

  void error(String tag, String message, [Object? error, StackTrace? stack]) {
    final detail = error == null ? message : '$message | $error';
    _enqueue('E', tag, detail, stack);
  }

  /// 等待已入队的写入全部落盘（上传前调用，保证文件内容完整）。
  Future<void> flush() async {
    try {
      await _chain;
      await _sink?.flush();
    } catch (_) {
      // 忽略——日志系统不抛错
    }
  }

  /// 现有日志文件，按日期倒序（上传页列表用）。
  Future<List<File>> listLogFiles() async {
    final dir = _dir;
    if (dir == null) return const [];
    try {
      final files = <File>[];
      await for (final e in dir.list()) {
        if (e is File && _dateOf(e) != null) files.add(e);
      }
      files.sort((a, b) => b.path.compareTo(a.path));
      return files;
    } catch (_) {
      return const [];
    }
  }

  // --- 内部实现 ---

  void _enqueue(String level, String tag, String message, [StackTrace? stack]) {
    if (kDebugMode) debugPrint('[$level][$tag] $message');
    if (_dir == null) return;
    _chain = _chain
        .then((_) => _write(level, tag, message, stack))
        .catchError((Object e) {
      if (kDebugMode) debugPrint('[LogService] write failed: $e');
    });
  }

  Future<void> _write(
      String level, String tag, String message, StackTrace? stack) async {
    final date = _dateString(now());
    if (date != _currentDate) await _openFor(date);
    final sink = _sink;
    if (sink == null || _capped) return;

    final buf = StringBuffer()
      ..write(_timestamp(now()))
      ..write(' [')
      ..write(level)
      ..write('] [')
      ..write(tag)
      ..write('] ')
      ..writeln(message);
    if (stack != null) buf.writeln(stack);
    final line = buf.toString();
    final bytes = line.length; // 估算即可，上限保护不必精确到多字节字符

    if (_currentSize + bytes > maxDailyBytes) {
      _capped = true;
      sink.writeln('${_timestamp(now())} [W] [Log] daily log capped');
      await sink.flush();
      return;
    }
    sink.write(line);
    _currentSize += bytes;
    await sink.flush();
  }

  /// 关旧文件、打开指定日期的日志文件（跨天轮转）。
  Future<void> _openFor(String date) async {
    final dir = _dir;
    if (dir == null) return;
    await _sink?.flush();
    await _sink?.close();
    final file = File('${dir.path}${Platform.pathSeparator}app_$date.log');
    _currentSize = await file.exists() ? await file.length() : 0;
    _sink = file.openWrite(mode: FileMode.append);
    _currentDate = date;
    _capped = _currentSize >= maxDailyBytes;
  }

  /// 删除 7 天前的日志文件（按文件名日期判断）。
  Future<void> _cleanup(Directory dir) async {
    final today = now();
    final cutoff = DateTime(today.year, today.month, today.day)
        .subtract(const Duration(days: _retentionDays - 1));
    await for (final e in dir.list()) {
      if (e is! File) continue;
      final date = _dateOf(e);
      if (date != null && date.isBefore(cutoff)) {
        try {
          await e.delete();
        } catch (_) {
          // 单个文件删除失败不影响其他清理
        }
      }
    }
  }

  /// 从 `app_YYYY-MM-DD.log` 文件名解析日期，非日志文件返回 null。
  DateTime? _dateOf(File f) {
    final name = f.uri.pathSegments.last;
    final m = RegExp(r'^app_(\d{4}-\d{2}-\d{2})\.log$').firstMatch(name);
    if (m == null) return null;
    return DateTime.tryParse(m.group(1)!);
  }

  String _dateString(DateTime t) =>
      '${t.year.toString().padLeft(4, '0')}-'
      '${t.month.toString().padLeft(2, '0')}-'
      '${t.day.toString().padLeft(2, '0')}';

  String _timestamp(DateTime t) =>
      '${_dateString(t)} '
      '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}:'
      '${t.second.toString().padLeft(2, '0')}.'
      '${t.millisecond.toString().padLeft(3, '0')}';
}
