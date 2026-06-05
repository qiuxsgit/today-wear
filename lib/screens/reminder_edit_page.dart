import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../models/reminder.dart';
import '../repositories/reminder_repository.dart';
import '../theme/app_theme_tokens.dart';

/// 新增/编辑提醒页
///
/// 支持设置提醒时间、选择重复星期、配置跳过选项。
/// 传入 [reminder] 为编辑模式，否则为新增模式。
class ReminderEditPage extends StatefulWidget {
  final Reminder? reminder;

  const ReminderEditPage({super.key, this.reminder});

  @override
  State<ReminderEditPage> createState() => _ReminderEditPageState();
}

class _ReminderEditPageState extends State<ReminderEditPage> {
  late final ReminderRepository _repository;
  late int _hour;
  late int _minute;
  late Set<int> _selectedWeekdays;
  late bool _skipIfRecorded;

  bool get _isEditMode => widget.reminder != null;
  bool _isSaving = false;

  static const List<int> _allWeekdays = [1, 2, 3, 4, 5, 6, 7];

  @override
  void initState() {
    super.initState();
    _repository = ReminderRepository();

    if (_isEditMode) {
      final r = widget.reminder!;
      _hour = r.hour;
      _minute = r.minute;
      _selectedWeekdays =
          r.weekdays.toSet();
      _skipIfRecorded = r.skipIfRecorded;
    } else {
      final now = DateTime.now();
      _hour = now.hour + 1;
      if (_hour > 23) _hour = 21;
      _minute = 0;
      _selectedWeekdays = {};
      _skipIfRecorded = true;
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    try {
      final weekdays = _selectedWeekdays.toList()..sort();
      if (_isEditMode) {
        await _repository.update(
          id: widget.reminder!.id,
          hour: _hour,
          minute: _minute,
          weekdays: weekdays,
          skipIfRecorded: _skipIfRecorded,
          isEnabled: widget.reminder!.isEnabled,
        );
      } else {
        await _repository.insert(
          hour: _hour,
          minute: _minute,
          weekdays: weekdays,
          skipIfRecorded: _skipIfRecorded,
          isEnabled: true,
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteReminder() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.reminderDelete),
        content: Text(l10n.reminderDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.reminderDelete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _repository.delete(widget.reminder!.id);
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hour, minute: _minute),
    );
    if (picked != null) {
      setState(() {
        _hour = picked.hour;
        _minute = picked.minute;
      });
    }
  }

  void _toggleWeekday(int day) {
    setState(() {
      if (_selectedWeekdays.contains(day)) {
        _selectedWeekdays.remove(day);
      } else {
        _selectedWeekdays.add(day);
      }
    });
  }

  String _dayName(int day, AppLocalizations l10n) {
    switch (day) {
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

  String _formatTime() {
    final h = _hour.toString().padLeft(2, '0');
    final m = _minute.toString().padLeft(2, '0');
    return '$h:$m';
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
          _isEditMode ? l10n.reminderEditTitle : l10n.reminderAddTitle,
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w800, color: tt.ink),
        ),
        centerTitle: true,
        actions: [
          if (_isEditMode)
            _RoundBtn(
              icon: Icons.delete_outline,
              onTap: _deleteReminder,
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 时间选择
            _buildSectionTitle(l10n.reminderTimeLabel, tt),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
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
                child: Text(
                  _formatTime(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: tt.ink,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 星期选择
            _buildSectionTitle(l10n.reminderWeekdaysLabel, tt),
            const SizedBox(height: 4),
            Text(
              _selectedWeekdays.isEmpty
                  ? l10n.reminderWeekdaysEveryday
                  : (_selectedWeekdays.toList()..sort())
                      .map((d) => _dayName(d, l10n))
                      .join('、'),
              style: TextStyle(fontSize: 12, color: tt.muted),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allWeekdays.map((day) {
                final isSelected = _selectedWeekdays.contains(day);
                return FilterChip(
                  label: Text(_dayName(day, l10n)),
                  selected: isSelected,
                  onSelected: (_) => _toggleWeekday(day),
                  backgroundColor: tt.surface,
                  selectedColor: tt.ink,
                  checkmarkColor: tt.page,
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? tt.page : tt.ink,
                  ),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 2),
                );
              }).toList(),
            ),

            if (_selectedWeekdays.isNotEmpty) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => setState(() => _selectedWeekdays.clear()),
                child: Text(
                  l10n.reminderWeekdaysEveryday,
                  style: TextStyle(fontSize: 12, color: tt.muted),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // 跳过选项
            Container(
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.reminderSkipLabel,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: tt.ink,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          l10n.reminderSkipHint,
                          style: TextStyle(
                              fontSize: 11, color: tt.muted),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _skipIfRecorded,
                    onChanged: (val) =>
                        setState(() => _skipIfRecorded = val),
                    activeTrackColor: tt.ink,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: tt.ink,
                foregroundColor: tt.page,
                disabledBackgroundColor: tt.muted,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                elevation: 0,
              ),
              child: _isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(tt.page),
                      ),
                    )
                  : Text(
                      l10n.reminderSave,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: tt.page,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppThemeTokens tt) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: tt.ink,
      ),
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
    // AppBar 的 leading/actions 会施加紧约束把子组件撑满，
    // 外层包 Center 释放约束，保证 42×42 尺寸生效（与外观页 _CircleBtn 一致）
    return Center(
      child: GestureDetector(
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
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Icon(icon, size: 18, color: tt.ink),
        ),
      ),
    );
  }
}
