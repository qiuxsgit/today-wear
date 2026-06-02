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

/// 主题色盘预设
enum ThemePresetType {
  softWardrobe,   // 柔和衣橱（默认）
  matcha,         // 清爽自然
  cityBlue,       // 利落现代
  roseEditorial,  // 柔粉杂志
  nightGallery,   // 夜间图库
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
  
  static const String _themeModeKey   = 'theme_mode';
  static const String _themePresetKey = 'theme_preset';

  ThemeModeType   _currentMode   = ThemeModeType.system;
  ThemePresetType _currentPreset = ThemePresetType.softWardrobe;
  Brightness _systemBrightness = Brightness.light;
  
  ThemeModeType   get currentMode   => _currentMode;
  ThemePresetType get currentPreset => _currentPreset;
  
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
  
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeIndex   = prefs.getInt(_themeModeKey)   ?? ThemeModeType.system.index;
      final presetIndex = prefs.getInt(_themePresetKey) ?? ThemePresetType.softWardrobe.index;
      _currentMode   = ThemeModeType.values[modeIndex];
      _currentPreset = ThemePresetType.values[presetIndex];
      notifyListeners();
    } catch (e) {
      debugPrint('ThemeService init error: $e');
    }
  }
  
  Future<void> setThemeMode(ThemeModeType mode) async {
    if (_currentMode != mode) {
      _currentMode = mode;
      await _saveThemeMode();
      notifyListeners();
    }
  }

  Future<void> setPreset(ThemePresetType preset) async {
    if (_currentPreset != preset) {
      _currentPreset = preset;
      await _savePreset();
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
  
  Future<void> _saveThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, _currentMode.index);
    } catch (e) {
      debugPrint('ThemeService save error: $e');
    }
  }

  Future<void> _savePreset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themePresetKey, _currentPreset.index);
    } catch (e) {
      debugPrint('ThemeService save preset error: $e');
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
  
  static IconData getModeIcon(ThemeModeType mode) {
    switch (mode) {
      case ThemeModeType.system: return Icons.brightness_auto;
      case ThemeModeType.light:  return Icons.wb_sunny_outlined;
      case ThemeModeType.dark:   return Icons.dark_mode_outlined;
    }
  }

  static String getPresetName(ThemePresetType preset) {
    switch (preset) {
      case ThemePresetType.softWardrobe:  return 'Soft Wardrobe';
      case ThemePresetType.matcha:        return 'Matcha Minimal';
      case ThemePresetType.cityBlue:      return 'City Blue';
      case ThemePresetType.roseEditorial: return 'Rose Editorial';
      case ThemePresetType.nightGallery:  return 'Night Gallery';
    }
  }

  static String getPresetDesc(ThemePresetType preset) {
    switch (preset) {
      case ThemePresetType.softWardrobe:  return '柔和衣橱 · 預設';
      case ThemePresetType.matcha:        return '清爽自然 · 日常通勤';
      case ThemePresetType.cityBlue:      return '利落現代 · 統計日曆';
      case ThemePresetType.roseEditorial: return '柔粉雜誌 · 漂亮但克制';
      case ThemePresetType.nightGallery:  return '夜間圖庫 · 沉浸瀏覽';
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
