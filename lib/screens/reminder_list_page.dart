import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../models/reminder.dart';
import '../repositories/reminder_repository.dart';
import '../services/notification_service.dart';
import '../theme/app_theme_tokens.dart';
import 'reminder_edit_page.dart';

/// 提醒列表页
///
/// 展示所有提醒卡片，支持启用/禁用切换和点击编辑。
/// 空状态时显示引导文案和新增按钮。
class ReminderListPage extends StatefulWidget {
  const ReminderListPage({super.key});

  @override
  State<ReminderListPage> createState() => _ReminderListPageState();
}

class _ReminderListPageState extends State<ReminderListPage> {
  late final ReminderRepository _repository;
  List<Reminder> _reminders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = ReminderRepository();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() => _isLoading = true);
    try {
      final reminders = await _repository.getAll();
      if (!mounted) return;
      setState(() {
        _reminders = reminders;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openEditPage({Reminder? reminder}) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ReminderEditPage(reminder: reminder),
      ),
    );
    if (changed == true) {
      await _loadReminders();
      // 提醒变更后重新调度通知
      await NotificationService.instance.rescheduleAll();
    }
  }

  Future<void> _toggleReminder(Reminder reminder, bool isEnabled) async {
    await _repository.toggle(reminder.id, isEnabled);
    await NotificationService.instance.rescheduleAll();
    await _loadReminders();
  }

  String _formatTime(int hour, int minute) {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _formatWeekdays(List<int> weekdays, AppLocalizations l10n) {
    if (weekdays.isEmpty) return l10n.reminderWeekdaysEveryday;
    String getDay(int d) {
      switch (d) {
        case 1: return l10n.reminderDayMon;
        case 2: return l10n.reminderDayTue;
        case 3: return l10n.reminderDayWed;
        case 4: return l10n.reminderDayThu;
        case 5: return l10n.reminderDayFri;
        case 6: return l10n.reminderDaySat;
        case 7: return l10n.reminderDaySun;
        default: return '';
      }
    }
    return weekdays.map(getDay).join('、');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tt = context.tt;

    return Scaffold(
      backgroundColor: tt.page,
      appBar: AppBar(
        backgroundColor: tt.page,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: _RoundBtn(
          icon: Icons.arrow_back_ios_new,
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.reminderTitle,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: tt.ink),
        ),
        centerTitle: true,
        actions: [
          _RoundBtn(
            icon: Icons.add,
            onTap: () => _openEditPage(),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reminders.isEmpty
              ? _buildEmptyState(l10n, tt)
              : _buildList(l10n, tt),
      floatingActionButton: _reminders.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _openEditPage(),
              backgroundColor: tt.ink,
              foregroundColor: tt.page,
              icon: const Icon(Icons.add, size: 20),
              label: Text(l10n.reminderAddBtn),
            )
          : null,
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n, AppThemeTokens tt) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_outlined, size: 64,
                color: tt.muted.withValues(alpha: 0.5)),
            const SizedBox(height: 24),
            Text(l10n.reminderEmptyMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: tt.muted, height: 1.5)),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => _openEditPage(),
              icon: const Icon(Icons.add, size: 20),
              label: Text(l10n.reminderAddBtn),
              style: FilledButton.styleFrom(
                backgroundColor: tt.ink,
                foregroundColor: tt.page,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(AppLocalizations l10n, AppThemeTokens tt) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      itemCount: _reminders.length,
      itemBuilder: (context, index) {
        final reminder = _reminders[index];
        final weekdays = reminder.weekdays;
        final isEnabled = reminder.isEnabled;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () => _openEditPage(reminder: reminder),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: tt.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F554230),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 时间显示
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isEnabled ? tt.ink : tt.mist,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      _formatTime(reminder.hour, reminder.minute),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isEnabled ? tt.page : tt.muted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 星期和跳过信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatWeekdays(weekdays, l10n),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isEnabled ? tt.ink : tt.muted,
                          ),
                        ),
                        if (reminder.skipIfRecorded)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              l10n.reminderSkipLabel,
                              style: TextStyle(
                                  fontSize: 11, color: tt.muted),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // 启用开关
                  Switch(
                    value: isEnabled,
                    onChanged: (val) => _toggleReminder(reminder, val),
                    activeTrackColor: tt.ink,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: tt.surface,
          shape: BoxShape.circle,
          border: Border.all(color: tt.line),
          boxShadow: const [
            BoxShadow(
                color: Color(0x14554230),
                blurRadius: 18,
                offset: Offset(0, 8)),
          ],
        ),
        child: Icon(icon, size: 18, color: tt.ink),
      ),
    );
  }
}
