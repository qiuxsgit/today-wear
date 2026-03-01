import 'package:flutter/material.dart';

/// App 全局颜色规范
///
/// 风格：简约、中性、克制
/// 目标用户：台湾地区 16–30 岁女性用户
/// 所有颜色常量集中管理，避免散落在页面中
/// 严格遵循 cursor-design-colors.mdc 设计规范
class AppColors {
  AppColors._();

  // ========== Brand Primary ==========

  /// 品牌主色（亮/暗模式通用）
  /// 值：#1A1A1A
  /// 用途：主按钮、选中态、强调操作、品牌识别色
  static const Color primary = Color(0xFF1A1A1A);

  /// 深色模式品牌主色（稍浅，提高对比度）
  /// 值：#E0E0E0
  static const Color primaryDark = Color(0xFFE0E0E0);

  // ========== Background Colors (Light Mode) ==========

  /// 页面主背景（亮色）
  /// 值：#FAFAFA
  /// 用途：页面主背景、全局 Scaffold 背景
  static const Color bgPrimary = Color(0xFFFAFAFA);

  /// 卡片背景（亮色）
  /// 值：#F5F5F5
  /// 用途：卡片背景、次级容器、列表 item 背景
  static const Color bgSecondary = Color(0xFFF5F5F5);

  /// 三级背景色（亮色）
  /// 值：#EEEEEE
  /// 用途：标签背景、小容器背景、装饰性背景
  static const Color bgTertiary = Color(0xFFEEEEEE);

  // ========== Background Colors (Dark Mode) ==========

  /// 页面主背景（深色）
  /// 值：#121212
  /// 用途：深色模式页面主背景
  static const Color bgPrimaryDark = Color(0xFF121212);

  /// 卡片背景（深色）
  /// 值：#1E1E1E
  /// 用途：深色模式卡片背景、次级容器
  static const Color bgSecondaryDark = Color(0xFF1E1E1E);

  /// 三级背景色（深色）
  /// 值：#2A2A2A
  /// 用途：深色模式标签背景、小容器
  static const Color bgTertiaryDark = Color(0xFF2A2A2A);

  /// App 全局背景色（兼容旧代码，等同于 bgPrimary）
  /// 值：#FAFAFA
  @Deprecated('使用 bgPrimary 替代')
  static const Color background = bgPrimary;

  // ========== Text Colors (Light Mode) ==========

  /// 主文字颜色（亮色）
  /// 值：#2F2F2F
  /// 用途：标题、主要正文、重要信息
  static const Color textPrimary = Color(0xFF2F2F2F);

  /// 次级文字颜色（亮色）
  /// 值：#7A7A7A
  /// 用途：描述文字、次要说明、时间/标签
  static const Color textSecondary = Color(0xFF7A7A7A);

  /// 占位文字颜色（亮色）
  /// 值：#B8B8B8
  /// 用途：占位文字、空状态说明
  static const Color textPlaceholder = Color(0xFFB8B8B8);

  // ========== Text Colors (Dark Mode) ==========

  /// 主文字颜色（深色）
  /// 值：#E0E0E0
  /// 用途：深色模式标题、主要正文
  static const Color textPrimaryDark = Color(0xFFE0E0E0);

  /// 次级文字颜色（深色）
  /// 值：#A0A0A0
  /// 用途：深色模式描述文字、次要说明
  static const Color textSecondaryDark = Color(0xFFA0A0A0);

  /// 占位文字颜色（深色）
  /// 值：#606060
  /// 用途：深色模式占位文字、空状态说明
  static const Color textPlaceholderDark = Color(0xFF606060);

  // ========== Accent / State Colors ==========

  /// 成功状态颜色（亮/暗模式通用）
  /// 值：#8FAE9E
  /// 用途：正向反馈、保存成功
  static const Color success = Color(0xFF8FAE9E);

  /// 警告状态颜色（亮/暗模式通用）
  /// 值：#D6A77A
  /// 用途：提醒、注意事项
  static const Color warning = Color(0xFFD6A77A);

  /// 错误状态颜色（亮/暗模式通用）
  /// 值：#C97C7C
  /// 用途：错误提示、删除确认
  static const Color error = Color(0xFFC97C7C);

  // ========== Timeline Colors ==========

  /// 时间线颜色（亮色）
  /// 值：#CCCCCC
  /// 用途：时间轴垂直线
  static const Color timelineLine = Color(0xFFCCCCCC);

  /// 时间线颜色（深色）
  /// 值：#404040
  static const Color timelineLineDark = Color(0xFF404040);

  /// 时间点颜色
  /// 值：#4A90E2
  /// 用途：时间轴圆点标记
  static const Color timelineDot = Color(0xFF4A90E2);

  /// 图片占位色（亮色）
  /// 值：#E8E8E8
  /// 用途：图片占位符背景
  static const Color imagePlaceholder = Color(0xFFE8E8E8);

  /// 图片占位色（深色）
  /// 值：#333333
  /// 用途：深色模式图片占位符背景
  static const Color imagePlaceholderDark = Color(0xFF333333);

  // ========== Helper Methods ==========

  /// 根据亮度模式获取背景主色
  static Color getBgPrimary(Brightness brightness) {
    return brightness == Brightness.dark ? bgPrimaryDark : bgPrimary;
  }

  /// 根据亮度模式获取卡片背景色
  static Color getBgSecondary(Brightness brightness) {
    return brightness == Brightness.dark ? bgSecondaryDark : bgSecondary;
  }

  /// 根据亮度模式获取三级背景色
  static Color getBgTertiary(Brightness brightness) {
    return brightness == Brightness.dark ? bgTertiaryDark : bgTertiary;
  }

  /// 根据亮度模式获取主文字颜色
  static Color getTextPrimary(Brightness brightness) {
    return brightness == Brightness.dark ? textPrimaryDark : textPrimary;
  }

  /// 根据亮度模式获取次级文字颜色
  static Color getTextSecondary(Brightness brightness) {
    return brightness == Brightness.dark ? textSecondaryDark : textSecondary;
  }

  /// 根据亮度模式获取占位文字颜色
  static Color getTextPlaceholder(Brightness brightness) {
    return brightness == Brightness.dark ? textPlaceholderDark : textPlaceholder;
  }

  /// 根据亮度模式获取时间线颜色
  static Color getTimelineLine(Brightness brightness) {
    return brightness == Brightness.dark ? timelineLineDark : timelineLine;
  }

  /// 根据亮度模式获取图片占位色
  static Color getImagePlaceholder(Brightness brightness) {
    return brightness == Brightness.dark ? imagePlaceholderDark : imagePlaceholder;
  }
}
