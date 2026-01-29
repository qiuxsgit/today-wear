import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:window_manager/window_manager.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import 'screens/home_page.dart';
import 'screens/add_outfit_page.dart';
import 'screens/profile_page.dart';
import 'theme/app_colors.dart';
import 'widgets/main_navigation.dart';
import 'services/locale_service.dart';
import 'database/database.dart';
import 'services/image_service.dart';

// 导出LocaleServiceProvider以便其他文件使用
export 'services/locale_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化语言服务
  final localeService = LocaleService();
  await localeService.init();
  
  // 初始化数据库（创建单例）
  AppDatabase();
  
  // 初始化图片目录
  await ImageService.instance.ensureImageDirectoriesExist();
  
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
  
  runApp(MyApp(localeService: localeService));
}

/// App 根组件
class MyApp extends StatefulWidget {
  final LocaleService localeService;
  
  const MyApp({
    super.key,
    required this.localeService,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 监听语言变化
    widget.localeService.addListener(_onLocaleChanged);
  }
  
  @override
  void dispose() {
    widget.localeService.removeListener(_onLocaleChanged);
    super.dispose();
  }
  
  void _onLocaleChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // 获取当前语言，如果没有则使用系统语言
    final locale = widget.localeService.currentLocale ??
        LocaleService.getSystemLocale(
          WidgetsBinding.instance.platformDispatcher.locales,
        );
    
    return LocaleServiceProvider(
      localeService: widget.localeService,
      child: MaterialApp(
        title: '今日穿什麼',
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: LocaleService.supportedLocales,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ).copyWith(
            primary: AppColors.primary,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.bgPrimary,
        ),
        home: const MainScreen(),
      ),
    );
  }
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
  int _selectedIndex = 0;
  
  // 标记是否需要刷新首页数据
  bool _needsRefresh = false;
  
  // 使用 GlobalKey 来访问 HomePage 的状态，以便刷新数据
  final GlobalKey<HomePageState> _homePageKey = GlobalKey<HomePageState>();
  // 使用 GlobalKey 来访问 AddOutfitPage 的状态
  final GlobalKey<AddOutfitPageState> _addOutfitPageKey = GlobalKey<AddOutfitPageState>();
  
  List<Widget> get _pages => [
    HomePage(
      key: _homePageKey,
      onAddFirstOutfit: () => setState(() => _selectedIndex = 1),
    ),
    AddOutfitPage(
      key: _addOutfitPageKey,
      onDataSaved: _onDataSaved,
    ),
    const ProfilePage(),
  ];
  
  /// 当数据保存成功时调用，标记需要刷新首页
  void _onDataSaved() {
    setState(() {
      _needsRefresh = true;
    });
  }
  
  void _onNavigationTap(int index) {
    // 如果切换到首页，检查是否需要刷新数据
    if (index == 0 && _needsRefresh) {
      if (_homePageKey.currentState != null) {
        _homePageKey.currentState!.refreshData();
      }
      setState(() {
        _needsRefresh = false;
        _selectedIndex = index;
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: MainNavigation(
        selectedIndex: _selectedIndex,
        onTap: _onNavigationTap,
      ),
    );
  }
}
