import 'package:flutter/material.dart';

/// 标签预设颜色（15 个）
///
/// 新建标签未选颜色时使用第一个作为默认
class TagColors {
  TagColors._();

  /// 默认颜色（第一个），新建标签时使用
  static const String defaultColorHex = '#E8F5E9';

  /// 15 个预设颜色 hex
  static const List<String> presetHex = [
    '#E8F5E9', // 1 浅绿
    '#E3F2FD', // 2 浅蓝
    '#FFF3E0', // 3 浅橙
    '#FCE4EC', // 4 浅粉
    '#F3E5F5', // 5 浅紫
    '#E0F7FA', // 6 浅青
    '#FFF8E1', // 7 浅黄
    '#EFEBE9', // 8 浅棕
    '#E8EAF6', // 9 浅靛
    '#FFEBEE', // 10 浅红
    '#E5E5E5', // 11 浅灰
    '#C8E6C9', // 12 绿
    '#BBDEFB', // 13 蓝
    '#FFCCBC', // 14 深橙
    '#D1C4E9', // 15 紫
  ];

  /// 将 hex 转为 Color，无效时返回默认色
  static Color fromHex(String hex) {
    if (hex.isEmpty || !hex.startsWith('#')) {
      return const Color(0xFFE8F5E9);
    }
    final h = hex.replaceFirst('#', '');
    if (h.length != 6 && h.length != 8) return const Color(0xFFE8F5E9);
    final value = int.tryParse(h, radix: 16);
    if (value == null) return const Color(0xFFE8F5E9);
    return Color(h.length == 8 ? value : (0xFF000000 | value));
  }
}
