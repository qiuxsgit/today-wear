import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder.dart';

/// 提醒数据仓库
///
/// 使用 SharedPreferences 存储提醒数据（JSON 序列化）。
class ReminderRepository {
  static const String _key = 'reminders';
  static int _nextId = 0;

  /// 读取所有提醒
  Future<List<Reminder>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];

    final list = jsonDecode(raw) as List<dynamic>;
    final reminders = list
        .map((e) => Reminder.fromJson(e as Map<String, dynamic>))
        .toList();

    for (final r in reminders) {
      if (r.id >= _nextId) _nextId = r.id + 1;
    }

    reminders.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return reminders;
  }

  Future<List<Reminder>> getEnabled() async {
    final all = await getAll();
    return all.where((r) => r.isEnabled).toList();
  }

  Future<int> getEnabledCount() async {
    final enabled = await getEnabled();
    return enabled.length;
  }

  Future<Reminder?> getById(int id) async {
    final all = await getAll();
    try {
      return all.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<Reminder> insert({
    required int hour,
    required int minute,
    required List<int> weekdays,
    required bool skipIfRecorded,
    required bool isEnabled,
  }) async {
    final all = await getAll();
    final reminder = Reminder(
      id: _nextId++,
      hour: hour,
      minute: minute,
      weekdays: weekdays,
      skipIfRecorded: skipIfRecorded,
      isEnabled: isEnabled,
      createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
    all.add(reminder);
    await _save(all);
    return reminder;
  }

  Future<bool> update({
    required int id,
    required int hour,
    required int minute,
    required List<int> weekdays,
    required bool skipIfRecorded,
    required bool isEnabled,
  }) async {
    final all = await getAll();
    final idx = all.indexWhere((r) => r.id == id);
    if (idx == -1) return false;

    all[idx] = all[idx].copyWith(
      hour: hour,
      minute: minute,
      weekdays: weekdays,
      skipIfRecorded: skipIfRecorded,
      isEnabled: isEnabled,
    );
    await _save(all);
    return true;
  }

  Future<bool> toggle(int id, bool isEnabled) async {
    final all = await getAll();
    final idx = all.indexWhere((r) => r.id == id);
    if (idx == -1) return false;

    all[idx] = all[idx].copyWith(isEnabled: isEnabled);
    await _save(all);
    return true;
  }

  Future<bool> delete(int id) async {
    final all = await getAll();
    final before = all.length;
    all.removeWhere((r) => r.id == id);
    if (all.length == before) return false;
    await _save(all);
    return true;
  }

  Future<void> _save(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(reminders.map((r) => r.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}
