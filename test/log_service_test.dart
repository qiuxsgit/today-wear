import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:today_wear/services/log_service.dart';

void main() {
  late Directory tempDir;
  late LogService log;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('log_service_test');
    log = LogService.forTesting();
  });

  tearDown(() async {
    await log.flush();
    await tempDir.delete(recursive: true);
  });

  File logFile(String date) =>
      File('${tempDir.path}${Platform.pathSeparator}logs'
          '${Platform.pathSeparator}app_$date.log');

  test('写入当日文件并带级别/tag', () async {
    log.now = () => DateTime(2026, 6, 5, 14, 23, 1, 123);
    await log.init(directory: tempDir);
    log.info('Sync', 'push 3 outfits');
    log.error('Api', 'POST /sync -> 500', Exception('boom'));
    await log.flush();

    final content = await logFile('2026-06-05').readAsString();
    expect(content, contains('2026-06-05 14:23:01.123 [I] [Sync] push 3 outfits'));
    expect(content, contains('[E] [Api] POST /sync -> 500 | Exception: boom'));
  });

  test('跨天自动轮转到新文件', () async {
    var current = DateTime(2026, 6, 5, 23, 59);
    log.now = () => current;
    await log.init(directory: tempDir);
    log.info('T', 'day one');
    await log.flush(); // 写入是异步入队的，先落盘再拨时钟
    current = DateTime(2026, 6, 6, 0, 1);
    log.info('T', 'day two');
    await log.flush();

    expect(await logFile('2026-06-05').readAsString(), contains('day one'));
    expect(await logFile('2026-06-06').readAsString(), contains('day two'));
  });

  test('init 清理 7 天前的文件，保留 7 天内的', () async {
    final logsDir = Directory('${tempDir.path}${Platform.pathSeparator}logs');
    await logsDir.create(recursive: true);
    // 今天 2026-06-10：保留窗口为 06-04 ~ 06-10
    await logFile('2026-06-03').writeAsString('old');
    await logFile('2026-06-04').writeAsString('edge keep');
    await logFile('2026-06-09').writeAsString('keep');
    await File('${logsDir.path}${Platform.pathSeparator}other.txt')
        .writeAsString('not a log');

    log.now = () => DateTime(2026, 6, 10, 8);
    await log.init(directory: tempDir);

    expect(await logFile('2026-06-03').exists(), isFalse);
    expect(await logFile('2026-06-04').exists(), isTrue);
    expect(await logFile('2026-06-09').exists(), isTrue);
    // 非日志文件不受清理影响
    expect(
      await File('${logsDir.path}${Platform.pathSeparator}other.txt').exists(),
      isTrue,
    );
  });

  test('超过单日上限后停止写入', () async {
    log.now = () => DateTime(2026, 6, 5, 10);
    log.maxDailyBytes = 200;
    await log.init(directory: tempDir);
    log.info('T', 'x' * 150); // 第一条在限内
    log.info('T', 'y' * 150); // 第二条触发封顶
    log.info('T', 'should not appear');
    await log.flush();

    final content = await logFile('2026-06-05').readAsString();
    expect(content, contains('x'));
    expect(content, contains('daily log capped'));
    expect(content, isNot(contains('should not appear')));
    expect(content, isNot(contains('yyy')));
  });

  test('listLogFiles 按日期倒序且只含日志文件', () async {
    final logsDir = Directory('${tempDir.path}${Platform.pathSeparator}logs');
    await logsDir.create(recursive: true);
    await logFile('2026-06-04').writeAsString('a');
    await logFile('2026-06-05').writeAsString('b');
    await File('${logsDir.path}${Platform.pathSeparator}other.txt')
        .writeAsString('x');

    log.now = () => DateTime(2026, 6, 5, 10);
    await log.init(directory: tempDir);
    final files = await log.listLogFiles();

    expect(files.map((f) => f.uri.pathSegments.last).toList(),
        ['app_2026-06-05.log', 'app_2026-06-04.log']);
  });

  test('未 init 时调用不抛错', () {
    expect(() => log.info('T', 'no init'), returnsNormally);
  });
}
