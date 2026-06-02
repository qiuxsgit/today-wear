import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../theme/app_theme_tokens.dart';

/// 暖色系主题模式选择器
///
/// pill 形容器 + 三段式切换：淺色 / 自動 / 深色
/// 激活段以 warmInk 背景 + 淺色文字呈現，匹配全局暖色設計語言
class ThemeModeSelector extends StatefulWidget {
  const ThemeModeSelector({super.key});

  @override
  State<ThemeModeSelector> createState() => _ThemeModeSelectorState();
}

class _ThemeModeSelectorState extends State<ThemeModeSelector> {
  late ThemeModeType _mode;

  @override
  void initState() {
    super.initState();
    _mode = ThemeService.instance.currentMode;
    ThemeService.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeService.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) setState(() => _mode = ThemeService.instance.currentMode);
  }

  void _select(ThemeModeType mode) {
    ThemeService.instance.setThemeMode(mode);
  }

  static const _segments = [
    (ThemeModeType.light,  Icons.wb_sunny_outlined, '淺色'),
    (ThemeModeType.system, Icons.brightness_auto,   '自動'),
    (ThemeModeType.dark,   Icons.dark_mode_outlined, '深色'),
  ];

  @override
  Widget build(BuildContext context) {
    final mist = context.tt.mist;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: mist,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: _segments.map((seg) {
          final (type, icon, label) = seg;
          final isActive = _mode == type;
          return Expanded(
            child: _Segment(
              icon: icon,
              label: label,
              isActive: isActive,
              onTap: () => _select(type),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _Segment({
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
    final surface = tt.surface;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isActive ? ink : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: isActive
              ? [const BoxShadow(color: Color(0x22554230), blurRadius: 12, offset: Offset(0, 4))]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                icon,
                key: ValueKey(isActive),
                size: 18,
                color: isActive ? surface : muted,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive ? surface : muted,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
