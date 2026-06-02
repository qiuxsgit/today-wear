import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// LocaleService的InheritedWidget包装器
class LocaleServiceProvider extends InheritedWidget {
  final LocaleService localeService;
  
  const LocaleServiceProvider({
    super.key,
    required this.localeService,
    required super.child,
  });
  
  static LocaleService? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocaleServiceProvider>()?.localeService;
  }
  
  @override
  bool updateShouldNotify(LocaleServiceProvider oldWidget) {
    return localeService != oldWidget.localeService;
  }
}

/// 语言服务类
/// 
/// 管理应用的语言设置和持久化
class LocaleService extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  
  /// 支持的语言列表
  static const List<Locale> supportedLocales = [
    Locale('zh', 'CN'), // 简体中文
    Locale('zh', 'TW'), // 繁体中文
    Locale('en'),       // 英文
    Locale('ja'),       // 日文
    Locale('ko'),       // 韩文
  ];
  
  /// 当前语言
  Locale? _currentLocale;
  
  /// 获取当前语言
  Locale? get currentLocale => _currentLocale;
  
  /// 初始化语言服务
  ///
  /// 从 SharedPreferences 加载保存的语言设置；首次启动时自动检测系统语言并持久化。
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final localeString = prefs.getString(_localeKey);

    if (localeString != null) {
      final parts = localeString.split('_');
      _currentLocale = parts.length == 2
          ? Locale(parts[0], parts[1])
          : Locale(parts[0]);
    } else {
      // 首次启动：检测系统语言，写入持久化，避免后续渲染语言与系统不一致
      final systemLocale = getSystemLocale(
        WidgetsBinding.instance.platformDispatcher.locales,
      );
      _currentLocale = systemLocale;
      final localeStr = systemLocale.countryCode != null
          ? '${systemLocale.languageCode}_${systemLocale.countryCode}'
          : systemLocale.languageCode;
      await prefs.setString(_localeKey, localeStr);
    }
    notifyListeners();
  }
  
  /// 设置语言
  /// 
  /// [locale] 要设置的语言
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) {
      return;
    }
    
    _currentLocale = locale;
    notifyListeners();
    
    // 持久化保存
    final prefs = await SharedPreferences.getInstance();
    final localeString = locale.countryCode != null
        ? '${locale.languageCode}_${locale.countryCode}'
        : locale.languageCode;
    await prefs.setString(_localeKey, localeString);
  }
  
  /// 获取系统语言
  /// 
  /// 如果系统语言在支持列表中，返回系统语言；否则返回英文
  static Locale getSystemLocale(List<Locale> systemLocales) {
    for (final systemLocale in systemLocales) {
      // 精确匹配
      for (final supported in supportedLocales) {
        if (supported.languageCode == systemLocale.languageCode &&
            supported.countryCode == systemLocale.countryCode) {
          return supported;
        }
      }
      
      // 语言代码匹配（忽略国家代码）
      for (final supported in supportedLocales) {
        if (supported.languageCode == systemLocale.languageCode) {
          return supported;
        }
      }
    }
    
    // 默认返回英文
    return supportedLocales[2]; // en
  }
}
