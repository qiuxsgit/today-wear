import 'package:flutter/material.dart';

/// App 全局颜色规范
///
/// 风格：柔和优雅、温暖治愈、少女感
/// 目标用户：16～30岁台湾、日本、韩国女性用户
/// 所有颜色常量集中管理，避免散落在页面中
/// 遵循 color-palette.md 设计规范
class AppColors {
  AppColors._();

  // ========== Brand Primary ==========

  /// 品牌主色 - 柔和樱花粉
  /// 值：#F8BBD0
  /// 用途：主按钮、选中态、强调操作、品牌识别色
  static const Color primary = Color(0xFFF8BBD0);

  // ========== Brand Secondary ==========

  /// 辅助色 - 柔和薰衣草紫
  /// 值：#E1BEE7
  /// 用途：次级按钮、标签、辅助强调
  static const Color secondary = Color(0xFFE1BEE7);

  ///  tertiary - 清新薄荷绿
  /// 值：#C8E6C9
  /// 用途：三级按钮、装饰性元素、特殊状态
  static const Color tertiary = Color(0xFFC8E6C9);

  /// 中性色 - 温暖米色
  /// 值：#F5F0E1
  /// 用途：中性背景、分隔区域、基础容器
  static const Color neutral = Color(0xFFF5F0E1);

  // ========== Background Colors ==========

  /// 页面主背景 - 纯白背景
  /// 值：#FFFFFF
  /// 用途：页面主背景、全局 Scaffold 背景
  static const Color bgPrimary = Color(0xFFFFFFFF);

  /// 卡片背景 - 浅灰背景
  /// 值：#FAFAFA
  /// 用途：卡片背景、次级容器、列表 item 背景
  static const Color bgSecondary = Color(0xFFFAFAFA);

  /// 三级背景色 - 极浅粉色
  /// 值：#FDF4F6
  /// 用途：标签背景、小容器背景、装饰性背景
  static const Color bgTertiary = Color(0xFFFDF4F6);

  /// App 全局背景色（兼容旧代码，等同于 bgPrimary）
  /// 值：#FFFFFF
  @Deprecated('使用 bgPrimary 替代')
  static const Color background = bgPrimary;

  // ========== Text Colors ==========

  /// 主文字颜色 - 深灰色
  /// 值：#2C2C2C
  /// 用途：标题、主要正文、重要信息
  static const Color textPrimary = Color(0xFF2C2C2C);

  /// 次级文字颜色 - 中灰色
  /// 值：#757575
  /// 用途：描述文字、次要说明、时间/标签
  static const Color textSecondary = Color(0xFF757575);

  /// 占位文字颜色 - 浅灰色
  /// 值：#BDBDBD
  /// 用途：占位文字、空状态说明
  static const Color textPlaceholder = Color(0xFFBDBDBD);

  // ========== Accent / State Colors ==========

  /// 成功状态颜色 - 柔和绿色
  /// 值：#A5D6A7
  /// 用途：正向反馈、保存成功
  static const Color success = Color(0xFFA5D6A7);

  /// 警告状态颜色 - 柔和黄色
  /// 值：#FFF9C4
  /// 用途：提醒、注意事项
  static const Color warning = Color(0xFFFFF9C4);

  /// 错误状态颜色 - 柔和红色
  /// 值：#E57373
  /// 用途：错误提示、删除确认
  static const Color error = Color(0xFFE57373);

  // ========== Timeline Colors ==========

  /// 时间线颜色 - 柔和蓝色
  /// 值：#E3F2FD
  /// 用途：时间轴垂直线
  static const Color timelineLine = Color(0xFFE3F2FD);

  /// 时间点颜色 - 柔和紫色
  /// 值：#CE93D8
  /// 用途：时间轴圆点标记
  static const Color timelineDot = Color(0xFFCE93D8);

  /// 图片占位色 - 极浅灰色
  /// 值：#F5F5F5
  /// 用途：图片占位符背景
  static const Color imagePlaceholder = Color(0xFFF5F5F5);
}
