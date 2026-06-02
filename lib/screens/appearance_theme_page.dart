import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../theme/app_theme_tokens.dart';
import '../theme/app_text_style.dart';
import '../widgets/theme_mode_selector.dart';

/// 外觀主題設定頁
///
/// 顯示模式：淺色 / 跟隨 / 深色
/// 主題色盤：5 套預設，點選立即切換
class AppearanceThemePage extends StatefulWidget {
  const AppearanceThemePage({super.key});

  @override
  State<AppearanceThemePage> createState() => _AppearanceThemePageState();
}

class _AppearanceThemePageState extends State<AppearanceThemePage> {
  late ThemePresetType _selected;

  @override
  void initState() {
    super.initState();
    _selected = ThemeService.instance.currentPreset;
    ThemeService.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeService.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) setState(() => _selected = ThemeService.instance.currentPreset);
  }

  void _selectPreset(ThemePresetType preset) {
    ThemeService.instance.setPreset(preset);
  }

  static const _allPresets = ThemePresetType.values;

  // 每套预设的色样（4 色，2×2 迷你网格）
  static List<Color> _swatches(ThemePresetType preset) {
    switch (preset) {
      case ThemePresetType.softWardrobe:
        return [
          AppThemeTokens.softWardrobeLight.ink,
          AppThemeTokens.softWardrobeLight.page,
          AppThemeTokens.softWardrobeLight.accent,
          AppThemeTokens.softWardrobeLight.mist,
        ];
      case ThemePresetType.matcha:
        return [
          AppThemeTokens.matchaLight.ink,
          AppThemeTokens.matchaLight.page,
          AppThemeTokens.matchaLight.accent,
          AppThemeTokens.matchaLight.mist,
        ];
      case ThemePresetType.cityBlue:
        return [
          AppThemeTokens.cityBlueLight.ink,
          AppThemeTokens.cityBlueLight.page,
          AppThemeTokens.cityBlueLight.accent,
          AppThemeTokens.cityBlueLight.mist,
        ];
      case ThemePresetType.roseEditorial:
        return [
          AppThemeTokens.roseLight.ink,
          AppThemeTokens.roseLight.page,
          AppThemeTokens.roseLight.accent,
          AppThemeTokens.roseLight.mist,
        ];
      case ThemePresetType.nightGallery:
        return [
          AppThemeTokens.nightGalleryDark.page,
          AppThemeTokens.nightGalleryDark.surface,
          AppThemeTokens.nightGalleryDark.accent,
          AppThemeTokens.nightGalleryDark.mist,
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    final ink = tt.ink;
    final muted = tt.muted;
    final page = tt.page;
    final surface = tt.surface;
    final line = tt.line;

    return Scaffold(
      backgroundColor: page,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部栏
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
              child: Row(
                children: [
                  _CircleBtn(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => Navigator.pop(context),
                    tt: tt,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '外觀主題',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: ink),
                      ),
                    ),
                  ),
                  _CircleBtn(
                    icon: Icons.check,
                    onTap: () => Navigator.pop(context),
                    tt: tt,
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 顯示模式
                    Text(
                      '顯示模式',
                      style: AppTextStyle.eyebrow.copyWith(color: muted),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [BoxShadow(color: Color(0x12554230), blurRadius: 24, offset: Offset(0, 10))],
                      ),
                      child: const ThemeModeSelector(),
                    ),

                    const SizedBox(height: 24),

                    // 主題色盤
                    Text(
                      '主題色盤',
                      style: AppTextStyle.eyebrow.copyWith(color: muted),
                    ),
                    const SizedBox(height: 10),

                    ...List.generate(_allPresets.length, (i) {
                      final preset = _allPresets[i];
                      final isSelected = preset == _selected;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ThemeRow(
                          preset: preset,
                          swatches: _swatches(preset),
                          isSelected: isSelected,
                          tt: tt,
                          onTap: () => _selectPreset(preset),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeRow extends StatelessWidget {
  final ThemePresetType preset;
  final List<Color> swatches;
  final bool isSelected;
  final AppThemeTokens tt;
  final VoidCallback onTap;

  const _ThemeRow({
    required this.preset,
    required this.swatches,
    required this.isSelected,
    required this.tt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: tt.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? tt.ink.withValues(alpha: 0.34)
                : tt.ink.withValues(alpha: 0.06),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x12554230),
              blurRadius: isSelected ? 28 : 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // 2×2 迷你色样
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                width: 54,
                height: 54,
                child: GridView.count(
                  crossAxisCount: 2,
                  physics: const NeverScrollableScrollPhysics(),
                  children: swatches
                      .map((c) => Container(color: c))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 名称 + 描述
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ThemeService.getPresetName(preset),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: tt.ink),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ThemeService.getPresetDesc(preset),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: tt.muted),
                  ),
                ],
              ),
            ),
            // 选中标记
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(color: tt.ink, shape: BoxShape.circle),
                child: Icon(Icons.check, size: 14, color: tt.surface),
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: tt.line, width: 1.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final AppThemeTokens tt;
  const _CircleBtn({required this.icon, required this.onTap, required this.tt});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: tt.surface,
          shape: BoxShape.circle,
          border: Border.all(color: tt.line),
          boxShadow: const [BoxShadow(color: Color(0x14554230), blurRadius: 18, offset: Offset(0, 8))],
        ),
        child: Icon(icon, size: 18, color: tt.ink),
      ),
    );
  }
}
