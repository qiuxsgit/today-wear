import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../theme/app_theme_tokens.dart';

/// 浮动胶囊式底部导航栏
///
/// 5 个 tab：首页 / 日历 / 新增 / 统计 / 个人
/// 样式：圆角胶囊 + 毛玻璃背景 + 激活圆点
class MainNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const MainNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tt = context.tt;
    final surface = tt.surface;

    final items = [
      (Icons.home_outlined, Icons.home, l10n.home),
      (Icons.calendar_today_outlined, Icons.calendar_today, '日曆'),
      (Icons.add, Icons.add, '新增'),
      (Icons.bar_chart_outlined, Icons.bar_chart, '統計'),
      (Icons.person_outline, Icons.person, l10n.profile),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: 58,
              decoration: BoxDecoration(
                color: surface.withAlpha(235),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x29554230),
                    blurRadius: 36,
                    offset: Offset(0, 18),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(items.length, (i) {
                  final (outlinedIcon, filledIcon, label) = items[i];
                  return _NavItem(
                    icon: selectedIndex == i ? filledIcon : outlinedIcon,
                    label: label,
                    isActive: selectedIndex == i,
                    onTap: () => onTap(i),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    final ink = tt.ink;
    final muted = tt.muted;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isActive ? ink : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 14,
                color: isActive ? const Color(0xFFFFFAF4) : muted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isActive ? ink : muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
