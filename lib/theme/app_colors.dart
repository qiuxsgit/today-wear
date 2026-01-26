import 'package:flutter/material.dart';

/// App 全局颜色规范
/// 
/// 风格：克制、日常、耐看
/// 所有颜色常量集中管理，避免散落在页面中
class AppColors {
  AppColors._();
  
  /// App 全局背景色
  /// 值：奶油白 #FFF8F2
  static const Color background = Color(0xFFFFF8F2);
  
  /// 主文字颜色
  /// 深灰 #333333
  static const Color textPrimary = Color(0xFF333333);
  
  /// 次级提示文字颜色
  /// 灰色 #888888
  static const Color textSecondary = Color(0xFF888888);
}
