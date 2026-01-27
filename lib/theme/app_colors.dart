import 'package:flutter/material.dart';

/// App 全局颜色规范
/// 
/// 风格：克制、日常、耐看
/// 所有颜色常量集中管理，避免散落在页面中
/// 遵循 cursor-design-colors.mdc 设计规范
class AppColors {
  AppColors._();
  
  // ========== Brand Primary ==========
  
  /// 品牌主色
  /// 值：#1A1A1A
  /// 用途：主按钮、选中态、强调操作、品牌识别色
  static const Color primary = Color(0xFF1A1A1A);
  
  // ========== Background Colors ==========
  
  /// 页面主背景
  /// 值：#FAFAFA
  /// 用途：页面主背景、全局 Scaffold 背景
  static const Color bgPrimary = Color(0xFFFAFAFA);
  
  /// 卡片背景
  /// 值：#F5F5F5
  /// 用途：卡片背景、次级容器、列表 item 背景
  static const Color bgSecondary = Color(0xFFF5F5F5);
  
  /// App 全局背景色（兼容旧代码，等同于 bgPrimary）
  /// 值：#FAFAFA
  @Deprecated('使用 bgPrimary 替代')
  static const Color background = bgPrimary;
  
  // ========== Text Colors ==========
  
  /// 主文字颜色
  /// 值：#2F2F2F
  /// 用途：标题、主要正文、重要信息
  static const Color textPrimary = Color(0xFF2F2F2F);
  
  /// 次级文字颜色
  /// 值：#7A7A7A
  /// 用途：描述文字、次要说明、时间/标签
  static const Color textSecondary = Color(0xFF7A7A7A);
  
  /// 占位文字颜色
  /// 值：#B8B8B8
  /// 用途：占位文字、空状态说明
  static const Color textPlaceholder = Color(0xFFB8B8B8);
  
  // ========== Accent / State Colors ==========
  
  /// 成功状态颜色
  /// 值：#8FAE9E
  /// 用途：正向反馈、保存成功
  static const Color success = Color(0xFF8FAE9E);
  
  /// 警告状态颜色
  /// 值：#D6A77A
  /// 用途：提醒、注意事项
  static const Color warning = Color(0xFFD6A77A);
  
  /// 错误状态颜色
  /// 值：#C97C7C
  /// 用途：错误提示、删除确认
  static const Color error = Color(0xFFC97C7C);
  
  // ========== Timeline Colors ==========
  
  /// 时间线颜色
  /// 值：#CCCCCC
  /// 用途：时间轴垂直线
  static const Color timelineLine = Color(0xFFCCCCCC);
  
  /// 时间点颜色
  /// 值：#4A90E2
  /// 用途：时间轴圆点标记
  static const Color timelineDot = Color(0xFF4A90E2);
  
  /// 图片占位色
  /// 值：#E8E8E8
  /// 用途：图片占位符背景
  static const Color imagePlaceholder = Color(0xFFE8E8E8);
}
