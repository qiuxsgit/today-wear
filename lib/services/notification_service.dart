import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../database/database.dart';
import '../repositories/reminder_repository.dart';
import '../repositories/outfit_repository.dart';
import '../screens/add_outfit_page.dart';

/// 通知服务
///
/// 封装本地通知的初始化、调度、取消和处理逻辑。
/// 支持通知栏快捷操作（拍照/选图）。
class NotificationService {
  static final NotificationService instance = NotificationService._();

  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// 全局导航 Key，用于从通知回调中导航
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 通知操作回调：true 表示从通知快捷操作触发
  static bool _pendingQuickAction = false;
  static String? _pendingActionType; // 'camera' 或 'gallery'

  /// 是否有待处理的快捷操作
  static bool get hasPendingQuickAction => _pendingQuickAction;

  /// 获取并清除待处理的快捷操作类型
  static String? consumePendingAction() {
    final action = _pendingActionType;
    _pendingActionType = null;
    _pendingQuickAction = false;
    return action;
  }

  /// 初始化通知插件
  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }

  /// 请求通知权限（iOS）
  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final iOS = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    bool? granted;

    if (android != null) {
      granted = await android.requestNotificationsPermission();
    }
    if (iOS != null) {
      granted = await iOS.requestPermissions(
        alert: true,
        badge: false,
        sound: true,
      );
    }

    return granted ?? false;
  }

  /// 处理通知点击或操作
  void _onNotificationResponse(NotificationResponse response) {
    final actionId = response.actionId;
    final context = navigatorKey.currentContext;
    if (context == null) return;

    if (actionId == 'camera') {
      _pendingQuickAction = true;
      _pendingActionType = 'camera';
      _openAddOutfitPage(context);
    } else if (actionId == 'gallery') {
      _pendingQuickAction = true;
      _pendingActionType = 'gallery';
      _openAddOutfitPage(context);
    } else {
      // 普通点击通知
      _pendingQuickAction = false;
      _pendingActionType = null;
      _openAddOutfitPage(context);
    }
  }

  /// 打开新增穿搭页
  void _openAddOutfitPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddOutfitPage(
          onDataSaved: () => Navigator.of(context).pop(true),
        ),
      ),
    );
  }

  /// 根据提醒数据调度所有通知
  ///
  /// 先取消所有现有通知，再根据数据库中的提醒重新调度。
  /// 建议在 App 启动、提醒变更后调用。
  Future<void> rescheduleAll() async {
    await _plugin.cancelAll();

    final db = AppDatabase();
    final reminderRepo = ReminderRepository();
    final outfitRepo = OutfitRepository(db);

    final reminders = await reminderRepo.getEnabled();
    if (reminders.isEmpty) return;

    // 检查今天是否已有记录
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final hasRecordToday = await _hasRecordToday(outfitRepo, todayStart);

    for (final reminder in reminders) {
      final weekdays = reminder.weekdays;
      final skipIfRecorded = reminder.skipIfRecorded;

      // 如果开启跳过且今天已有记录，跳过今天
      final todayWeekday = now.weekday; // Mon=1..Sun=7
      final shouldScheduleToday = !(skipIfRecorded && hasRecordToday) &&
          (weekdays.isEmpty || weekdays.contains(todayWeekday));

      // 检查今天的时间是否已过
      if (shouldScheduleToday) {
        final scheduledTime = DateTime(
          now.year,
          now.month,
          now.day,
          reminder.hour,
          reminder.minute,
        );
        if (scheduledTime.isAfter(now)) {
          // 今天的时间还没到，调度今天
          await _scheduleOneShot(
            id: reminder.id * 10 + todayWeekday,
            hour: reminder.hour,
            minute: reminder.minute,
            dayOfWeek: todayWeekday,
          );
        }
      }

      // 为每个选中的星期调度（从明天开始的未来 7 天）
      final daysToSchedule = weekdays.isEmpty
          ? [1, 2, 3, 4, 5, 6, 7]
          : weekdays;

      for (final weekday in daysToSchedule) {
        if (weekday == todayWeekday && shouldScheduleToday) {
          continue; // 今天已经用 one-shot 调度了
        }

        // 计算下一个 weekday 的日期
        final nextDate = _nextWeekday(now, weekday);
        final notificationId = reminder.id * 10 + weekday;

        await _scheduleOneShot(
          id: notificationId,
          hour: reminder.hour,
          minute: reminder.minute,
          date: nextDate,
        );
      }
    }
  }

  /// 调度一次通知
  Future<void> _scheduleOneShot({
    required int id,
    required int hour,
    required int minute,
    int? dayOfWeek,
    DateTime? date,
  }) async {
    DateTime scheduledDate;
    if (date != null) {
      scheduledDate = date;
    } else if (dayOfWeek != null) {
      scheduledDate = _nextWeekday(DateTime.now(), dayOfWeek);
    } else {
      return;
    }

    scheduledDate = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      hour,
      minute,
    );

    final now = DateTime.now();
    if (scheduledDate.isBefore(now)) return;

    final androidDetails = AndroidNotificationDetails(
      'daily_reminder',
      '每日穿搭提醒',
      channelDescription: '提醒你记录每日穿搭',
      importance: Importance.high,
      priority: Priority.high,
      actions: [
        const AndroidNotificationAction(
          'camera',
          '📷 拍照记录',
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          'gallery',
          '🖼 从相册选择',
          showsUserInterface: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      categoryIdentifier: 'daily_reminder',
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      id,
      '今日穿搭',
      '别忘了记录今天的穿搭哦～',
      tz.TZDateTime.from(scheduledDate, tz.UTC),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// 计算下一个指定 weekday 的日期（超过 7 天范围则取下周）
  DateTime _nextWeekday(DateTime from, int targetWeekday) {
    int daysUntil = targetWeekday - from.weekday;
    if (daysUntil <= 0) {
      daysUntil += 7;
    }
    final next = from.add(Duration(days: daysUntil));
    return DateTime(next.year, next.month, next.day);
  }

  /// 取消指定提醒的所有通知
  Future<void> cancelReminder(int reminderId) async {
    // 取消该 reminder 关联的所有 notification（weekday 1-7）
    for (int weekday = 1; weekday <= 7; weekday++) {
      await _plugin.cancel(reminderId * 10 + weekday);
    }
  }

  /// 检查今天是否已有穿搭记录
  Future<bool> _hasRecordToday(
      OutfitRepository repo, DateTime todayStart) async {
    try {
      final todayEnd = todayStart.add(const Duration(days: 1));
      final outfits = await repo.getOutfitsByDateRange(todayStart, todayEnd);
      return outfits.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
