import 'dart:convert';

/// 提醒数据模型
class Reminder {
  final int id;
  final int hour;
  final int minute;
  final List<int> weekdays; // 空列表表示每天
  final bool skipIfRecorded;
  final bool isEnabled;
  final int createdAt;

  const Reminder({
    required this.id,
    required this.hour,
    required this.minute,
    required this.weekdays,
    required this.skipIfRecorded,
    required this.isEnabled,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'hour': hour,
        'minute': minute,
        'weekdays': jsonEncode(weekdays),
        'skipIfRecorded': skipIfRecorded,
        'isEnabled': isEnabled,
        'createdAt': createdAt,
      };

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        id: json['id'] as int,
        hour: json['hour'] as int,
        minute: json['minute'] as int,
        weekdays: (jsonDecode(json['weekdays'] as String) as List<dynamic>)
            .map((e) => e as int)
            .toList(),
        skipIfRecorded: json['skipIfRecorded'] as bool,
        isEnabled: json['isEnabled'] as bool,
        createdAt: json['createdAt'] as int,
      );

  Reminder copyWith({
    int? id,
    int? hour,
    int? minute,
    List<int>? weekdays,
    bool? skipIfRecorded,
    bool? isEnabled,
    int? createdAt,
  }) =>
      Reminder(
        id: id ?? this.id,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        weekdays: weekdays ?? this.weekdays,
        skipIfRecorded: skipIfRecorded ?? this.skipIfRecorded,
        isEnabled: isEnabled ?? this.isEnabled,
        createdAt: createdAt ?? this.createdAt,
      );
}
