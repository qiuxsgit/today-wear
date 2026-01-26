/// App 间距系统规范
/// 
/// 仅定义 4 个固定间距，禁止新增：
/// - xs = 8：最小间距
/// - sm = 12：卡片内部间距
/// - md = 16：页面 Padding
/// - lg = 24：区块之间间距
class AppSpacing {
  AppSpacing._();
  
  /// 最小间距：8
  static const double xs = 8.0;
  
  /// 卡片内部间距：12
  static const double sm = 12.0;
  
  /// 页面 Padding：16
  static const double md = 16.0;
  
  /// 区块之间间距：24
  static const double lg = 24.0;
}
