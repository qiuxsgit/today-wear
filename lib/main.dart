import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:window_manager/window_manager.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import 'screens/home_page.dart';
import 'screens/add_outfit_page.dart';
import 'screens/calendar_page.dart';
import 'screens/statistics_page.dart';
import 'screens/profile_page.dart';
import 'theme/app_theme_tokens.dart';
import 'widgets/main_navigation.dart';
import 'services/locale_service.dart';
import 'services/log_service.dart';
import 'services/theme_service.dart';
import 'services/notification_service.dart';
import 'database/database.dart';
import 'services/image_service.dart';
import 'services/purchase_service.dart';
import 'services/session_service.dart';
import 'services/sync_service.dart';
import 'services/update_service.dart';
import 'services/weather_service.dart';
import 'widgets/update_dialog.dart';

// 导出 LocaleServiceProvider 以便其他文件使用
export 'services/locale_service.dart';
// 导出 ThemeService 以便其他文件使用
export 'services/theme_service.dart';

AppThemeTokens _tokensFor(ThemePresetType preset, Brightness brightness) {
  final dark = brightness == Brightness.dark;
  switch (preset) {
    case ThemePresetType.softWardrobe:
      return dark ? AppThemeTokens.softWardrobeDark : AppThemeTokens.softWardrobeLight;
    case ThemePresetType.matcha:
      return dark ? AppThemeTokens.matchaDark : AppThemeTokens.matchaLight;
    case ThemePresetType.cityBlue:
      return dark ? AppThemeTokens.cityBlueDark : AppThemeTokens.cityBlueLight;
    case ThemePresetType.roseEditorial:
      return dark ? AppThemeTokens.roseDark : AppThemeTokens.roseLight;
    case ThemePresetType.nightGallery:
      return dark ? AppThemeTokens.nightGalleryDark : AppThemeTokens.nightGalleryLight;
  }
}

ThemeData _buildTheme(ThemePresetType preset, Brightness brightness) {
  final tt = _tokensFor(preset, brightness);
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: tt.ink,
      brightness: brightness,
    ).copyWith(
      primary: tt.ink,
      surface: tt.surface,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: tt.page,
    cardColor: tt.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: tt.surface,
      foregroundColor: tt.ink,
      elevation: 0,
    ),
    extensions: [tt],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 最先初始化日志服务，保证能记录后续初始化过程的错误
  await LogService.instance.init();
  _installErrorLogging();

  // 初始化语言服务
  final localeService = LocaleService();
  await localeService.init();
  
  // 初始化主题服务
  final themeService = ThemeService.instance;
  await themeService.init();
  
  // 初始化数据库（创建单例）
  AppDatabase();

  // 初始化会话服务（恢复登录态 + 注入 ApiClient token）
  await SessionService.instance.init();

  // 恢复同步元数据，并机会性触发一次后台同步（未登录时内部直接跳过）
  await SyncService.instance.loadMeta();
  SyncService.instance.syncInBackground();

  // 初始化订阅服务（RevenueCat；不支持的平台/失败时自动降级，不阻塞启动）
  unawaited(PurchaseService.instance.init());

  // 初始化图片目录
  await ImageService.instance.ensureImageDirectoriesExist();

  // 初始化通知服务
  final notificationService = NotificationService.instance;
  await notificationService.init();
  await notificationService.rescheduleAll();
  
  // macOS 专用调试配置：将窗口设置为手机比例（iPhone 14/15: 390 × 844）
  if (Platform.isMacOS) {
    await windowManager.ensureInitialized();
    
    const windowOptions = WindowOptions(
      size: Size(390, 844),
      minimumSize: Size(390, 844),
      maximumSize: Size(390, 844),
      center: true,
    );
    
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  
  runApp(MyApp(
    localeService: localeService,
    themeService: themeService,
    notificationService: notificationService,
  ));
}

/// 把未捕获异常接入日志：记录后转交原 handler，不改变现有崩溃行为
void _installErrorLogging() {
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    LogService.instance.error(
      'Crash',
      'FlutterError: ${details.exceptionAsString()}',
      null,
      details.stack,
    );
    previousOnError?.call(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    LogService.instance.error('Crash', 'Uncaught', error, stack);
    return false; // 维持框架默认处理
  };
}

/// App 根组件
class MyApp extends StatefulWidget {
  final LocaleService localeService;
  final ThemeService themeService;
  final NotificationService notificationService;

  const MyApp({
    super.key,
    required this.localeService,
    required this.themeService,
    required this.notificationService,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 监听语言变化
    widget.localeService.addListener(_onLocaleChanged);
    // 监听主题变化
    widget.themeService.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.localeService.removeListener(_onLocaleChanged);
    widget.themeService.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 回到前台时机会性触发云同步（未登录/未开启时内部直接跳过）
    if (state == AppLifecycleState.resumed) {
      SyncService.instance.syncInBackground();
      // 回前台静默刷新天气（service 内部 30 分钟缓存去重，已有数据不闪 loading；
      // 也覆盖"从系统设置开权限返回"的场景）
      WeatherService.instance.load();
    }
  }
  
  void _onLocaleChanged() {
    setState(() {});
    // 天气状况文字由服务端按 lang 本地化，语言切换后强刷
    WeatherService.instance.load(force: true);
  }
  
  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // 获取当前语言，如果没有则使用系统语言
    final locale = widget.localeService.currentLocale ??
        LocaleService.getSystemLocale(
          WidgetsBinding.instance.platformDispatcher.locales,
        );

    // 监听系统亮度变化（用于跟随系统模式）
    // 注意：需要在 build 外部设置监听器，这里在 initState 中处理
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    // 异步更新亮度，避免在 build 中调用 setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.themeService.updateSystemBrightness(brightness);
    });
    
    return ThemeServiceProvider(
      themeService: widget.themeService,
      child: LocaleServiceProvider(
        localeService: widget.localeService,
        child: MaterialApp(
          title: '今日穿什麼',
          navigatorKey: widget.notificationService.navigatorKey,
          locale: locale,
          scrollBehavior: const _TightBounceScrollBehavior(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: LocaleService.supportedLocales,
          themeMode: widget.themeService.themeMode,
          theme:     _buildTheme(widget.themeService.currentPreset, Brightness.light),
          darkTheme: _buildTheme(widget.themeService.currentPreset, Brightness.dark),
          home: const MainScreen(),
        ),
      ),
    );
  }
}

/// 全局滚动行为
///
/// - 关掉 Android 默认 `StretchingOverscrollIndicator`（整体拉伸会让头像等元素变形）
/// - 改用紧凑版 `BouncingScrollPhysics`：拉得短、回弹快，仍保留弹性反馈
class _TightBounceScrollBehavior extends MaterialScrollBehavior {
  const _TightBounceScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const _TightBouncingScrollPhysics();
  }
}

/// 紧凑回弹的滚动物理
///
/// - `frictionFactor` 调小 → 同样的拖动手势，实际能拉出的距离更短
/// - `spring` 加硬 + 轻量 → 回弹更快
class _TightBouncingScrollPhysics extends BouncingScrollPhysics {
  const _TightBouncingScrollPhysics({super.parent})
      : super(decelerationRate: ScrollDecelerationRate.fast);

  @override
  _TightBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _TightBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  /// 默认实现是 `0.52 * (1 - overscrollFraction)^2`
  /// 这里降到 0.2，等价于"用同样的力，只能拉出原来约 40% 的距离"
  @override
  double frictionFactor(double overscrollFraction) {
    return 0.2 * math.pow(1 - overscrollFraction, 2).toDouble();
  }

  /// 默认 mass=0.5 stiffness=100 damping=1.0（严重欠阻尼，会震荡）
  ///
  /// 这里临界阻尼 c = 2·√(m·k) = 2·√(0.3·220) ≈ 16.25
  /// 设 18（略过阻尼）确保回弹单调收敛到边界，不来回震荡
  @override
  SpringDescription get spring => const SpringDescription(
        mass: 0.3,
        stiffness: 220,
        damping: 18,
      );
}

/// 主应用框架
/// 
/// 管理底部导航栏状态和页面切换
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// 0: 首页 / 1: 日历 / 2: 新增 / 3: 统计 / 4: 个人
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // 主页加载完成后静默检查版本（失败完全静默；强更/新版弹窗）
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await UpdateService.instance.checkOnLaunch();
      if (result != null && mounted) {
        await showUpdateDialog(context, result);
      }
    });
  }

  /// 标记是否需要刷新首页数据
  bool _needsRefresh = false;

  final GlobalKey<HomePageState> _homePageKey = GlobalKey<HomePageState>();

  List<Widget> get _pages => [
        HomePage(
          key: _homePageKey,
          onAddFirstOutfit: _openAddOutfit,
        ),
        const CalendarPage(),
        const SizedBox.shrink(), // 占位：新增 tab (index 2)，不展示页面
        const StatisticsPage(),
        const ProfilePage(),
      ];

  void _onNavigationTap(int index) {
    // 中间新增 tab：直接打开新增穿搭页，不切换页面
    if (index == 2) {
      _openAddOutfit();
      return;
    }
    if (index == 0 && _needsRefresh) {
      _homePageKey.currentState?.refreshData();
      setState(() {
        _needsRefresh = false;
        _selectedIndex = index;
      });
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  /// 打开新增穿搭页（导航栏新增 tab 入口）
  /// 保存成功后 pop(true)，回调里立即刷新当前页或标记首页需刷新
  Future<void> _openAddOutfit() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (ctx) => AddOutfitPage(
          onDataSaved: () => Navigator.of(ctx).pop(true),
        ),
      ),
    );
    if (saved != true || !mounted) return;
    // 穿搭保存后重新调度通知（可能会因为 skipIfRecorded 跳过今天）
    NotificationService.instance.rescheduleAll();
    // 机会性触发云同步推送
    SyncService.instance.syncInBackground();
    if (_selectedIndex == 0) {
      _homePageKey.currentState?.refreshData();
      _needsRefresh = false;
    } else {
      _needsRefresh = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: MainNavigation(
        selectedIndex: _selectedIndex,
        onTap: _onNavigationTap,
      ),
    );
  }
}
