import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 主题服务模式
enum ThemeModeType {
  /// 跟随系统
  system,
  
  /// 浅色模式
  light,
  
  /// 深色模式
  dark,
}

/// 主题管理服务
/// 
/// 负责管理应用主题切换，支持：
/// - 手动切换浅色/深色模式
/// - 跟随系统自动切换
/// - 持久化用户偏好
class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._();
  
  ThemeService._();
  
  static ThemeService get instance => _instance;
  
  /// SharedPreferences 键名
  static const String _themeModeKey = 'theme_mode';
  
  /// 当前主题模式
  ThemeModeType _currentMode = ThemeModeType.system;
  
  /// 系统当前亮度模式
  Brightness _systemBrightness = Brightness.light;
  
  /// 获取当前主题模式
  ThemeModeType get currentMode => _currentMode;
  
  /// 获取系统亮度模式
  Brightness get systemBrightness => _systemBrightness;
  
  /// 获取实际应用的亮度模式（考虑系统模式）
  Brightness get effectiveBrightness {
    if (_currentMode == ThemeModeType.system) {
      return _systemBrightness;
    }
    return _currentMode == ThemeModeType.dark ? Brightness.dark : Brightness.light;
  }
  
  /// 获取 Flutter ThemeMode
  ThemeMode get themeMode {
    switch (_currentMode) {
      case ThemeModeType.light:
        return ThemeMode.light;
      case ThemeModeType.dark:
        return ThemeMode.dark;
      case ThemeModeType.system:
        return ThemeMode.system;
    }
  }
  
  /// 初始化主题服务
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeIndex = prefs.getInt(_themeModeKey) ?? ThemeModeType.system.index;
      _currentMode = ThemeModeType.values[modeIndex];
      notifyListeners();
    } catch (e) {
      debugPrint('ThemeService init error: $e');
    }
  }
  
  /// 设置主题模式
  Future<void> setThemeMode(ThemeModeType mode) async {
    if (_currentMode != mode) {
      _currentMode = mode;
      await _saveThemeMode();
      notifyListeners();
    }
  }
  
  /// 切换深色/浅色模式（快捷切换）
  Future<void> toggleDarkMode() async {
    if (_currentMode == ThemeModeType.dark) {
      await setThemeMode(ThemeModeType.light);
    } else {
      await setThemeMode(ThemeModeType.dark);
    }
  }
  
  /// 更新系统亮度模式
  void updateSystemBrightness(Brightness brightness) {
    if (_systemBrightness != brightness) {
      _systemBrightness = brightness;
      if (_currentMode == ThemeModeType.system) {
        notifyListeners();
      }
    }
  }
  
  /// 保存主题模式到本地存储
  Future<void> _saveThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, _currentMode.index);
    } catch (e) {
      debugPrint('ThemeService save error: $e');
    }
  }
  
  /// 获取主题模式显示名称
  static String getModeName(ThemeModeType mode) {
    switch (mode) {
      case ThemeModeType.system:
        return '跟随系统';
      case ThemeModeType.light:
        return '浅色模式';
      case ThemeModeType.dark:
        return '深色模式';
    }
  }
  
  /// 获取主题模式图标
  static IconData getModeIcon(ThemeModeType mode) {
    switch (mode) {
      case ThemeModeType.system:
        return Icons.brightness_auto;
      case ThemeModeType.light:
        return Icons.light_mode;
      case ThemeModeType.dark:
        return Icons.dark_mode;
    }
  }
}

/// 主题服务提供商组件
/// 
/// 用于在 Widget 树中提供主题服务
class ThemeServiceProvider extends StatefulWidget {
  final ThemeService themeService;
  final Widget child;
  
  const ThemeServiceProvider({
    super.key,
    required this.themeService,
    required this.child,
  });

  @override
  State<ThemeServiceProvider> createState() => _ThemeServiceProviderState();
}

class _ThemeServiceProviderState extends State<ThemeServiceProvider> {
  @override
  void initState() {
    super.initState();
    widget.themeService.addListener(_onThemeChanged);
  }
  
  @override
  void dispose() {
    widget.themeService.removeListener(_onThemeChanged);
    super.dispose();
  }
  
  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
