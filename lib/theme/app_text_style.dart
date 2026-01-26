import 'package:flutter/material.dart';
import 'app_colors.dart';

/// App 字体节奏规范
/// 
/// 仅定义 3 种文本样式：
/// - title: 标题样式（18px, semi-bold）
/// - body: 正文样式（14px, regular）
/// - hint: 提示文字样式（12px, regular, 次级颜色）
/// 
/// 使用系统默认字体，不引入自定义字体
class AppTextStyle {
  AppTextStyle._();
  
  /// 标题样式
  /// fontSize: 18
  /// fontWeight: semi-bold (600)
  /// color: 主文字色
  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  /// 正文样式
  /// fontSize: 14
  /// color: 主文字色
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  /// 提示文字样式
  /// fontSize: 12
  /// color: 次级文字色
  static const TextStyle hint = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}
