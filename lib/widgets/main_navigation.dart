import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../theme/app_colors.dart';

/// 底部导航栏组件
/// 
/// 使用 Material 3 的 NavigationBar
class MainNavigation extends StatelessWidget {
  /// 当前选中的索引
  final int selectedIndex;
  
  /// 索引变化回调
  final ValueChanged<int> onTap;
  
  const MainNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onTap,
      backgroundColor: Colors.white,
      indicatorColor: AppColors.bgSecondary,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: l10n.home,
        ),
        NavigationDestination(
          icon: const Icon(Icons.add_circle_outline),
          selectedIcon: const Icon(Icons.add_circle),
          label: l10n.add,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: l10n.profile,
        ),
      ],
    );
  }
}
