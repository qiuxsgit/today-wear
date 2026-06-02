import 'package:flutter/material.dart';

/// 全局主题 token 系统
///
/// 通过 Flutter ThemeExtension 注入，让自定义 Widget 能随主题预设切换颜色。
/// 每套预设提供 light + dark 两组 token，分别挂在 ThemeData.theme / darkTheme 上。
/// Widget 通过 `context.tt` 取到当前模式对应的 token 组，无需手动判断 Brightness。
@immutable
class AppThemeTokens extends ThemeExtension<AppThemeTokens> {
  const AppThemeTokens({
    required this.ink,
    required this.page,
    required this.surface,
    required this.accent,
    required this.mist,
    required this.muted,
    required this.line,
  });

  /// 主色（文字、按钮、激活态）
  final Color ink;
  /// 页面背景
  final Color page;
  /// 卡片表面
  final Color surface;
  /// 强调色（date box、高亮点）
  final Color accent;
  /// 标签 / chip 背景
  final Color mist;
  /// 次级文字
  final Color muted;
  /// 分隔线 / 描边
  final Color line;

  // ────────────────────────────────────────────
  // 5 套主题 × 2 模式 = 10 个实例
  // ────────────────────────────────────────────

  static const softWardrobeLight = AppThemeTokens(
    ink:     Color(0xFF25221F),
    page:    Color(0xFFFBF8F3),
    surface: Color(0xFFFFFDF9),
    accent:  Color(0xFFC78363),
    mist:    Color(0xFFF4EFE7),
    muted:   Color(0xFF7C746D),
    line:    Color(0xFFECE6DF),
  );
  static const softWardrobeDark = AppThemeTokens(
    ink:     Color(0xFFECE6DF),
    page:    Color(0xFF1C1917),
    surface: Color(0xFF252220),
    accent:  Color(0xFFC78363),
    mist:    Color(0xFF2E2A25),
    muted:   Color(0xFF9C9189),
    line:    Color(0xFF3A3530),
  );

  static const matchaLight = AppThemeTokens(
    ink:     Color(0xFF486554),
    page:    Color(0xFFF7F8F2),
    surface: Color(0xFFFFFFFF),
    accent:  Color(0xFF8AA07B),
    mist:    Color(0xFFE4EADB),
    muted:   Color(0xFF6F7B70),
    line:    Color(0xFFD4DFCD),
  );
  static const matchaDark = AppThemeTokens(
    ink:     Color(0xFFD8EDD9),
    page:    Color(0xFF141A16),
    surface: Color(0xFF1D2820),
    accent:  Color(0xFF8AA07B),
    mist:    Color(0xFF222D24),
    muted:   Color(0xFF8B9D8B),
    line:    Color(0xFF2A3A2C),
  );

  static const cityBlueLight = AppThemeTokens(
    ink:     Color(0xFF3F68A8),
    page:    Color(0xFFF6F8FB),
    surface: Color(0xFFFFFFFF),
    accent:  Color(0xFF7396BF),
    mist:    Color(0xFFE6EDF7),
    muted:   Color(0xFF6E7A8A),
    line:    Color(0xFFCCDAED),
  );
  static const cityBlueDark = AppThemeTokens(
    ink:     Color(0xFFB8CFF0),
    page:    Color(0xFF141921),
    surface: Color(0xFF1C2433),
    accent:  Color(0xFF7396BF),
    mist:    Color(0xFF1C2A40),
    muted:   Color(0xFF7D8EA0),
    line:    Color(0xFF253348),
  );

  static const roseLight = AppThemeTokens(
    ink:     Color(0xFF7B4B54),
    page:    Color(0xFFFCF6F6),
    surface: Color(0xFFFFFFFF),
    accent:  Color(0xFFD79AA5),
    mist:    Color(0xFFF0DDE1),
    muted:   Color(0xFF806C70),
    line:    Color(0xFFE8CFCF),
  );
  static const roseDark = AppThemeTokens(
    ink:     Color(0xFFEDD5D8),
    page:    Color(0xFF1E1517),
    surface: Color(0xFF2A1D20),
    accent:  Color(0xFFD79AA5),
    mist:    Color(0xFF321F24),
    muted:   Color(0xFF907378),
    line:    Color(0xFF3D2528),
  );

  static const nightGalleryLight = AppThemeTokens(
    ink:     Color(0xFF35312C),
    page:    Color(0xFFFAF7F2),
    surface: Color(0xFFF5F0E8),
    accent:  Color(0xFFC9A46A),
    mist:    Color(0xFFEDE5D8),
    muted:   Color(0xFF8B8278),
    line:    Color(0xFFE0D8CC),
  );
  static const nightGalleryDark = AppThemeTokens(
    ink:     Color(0xFFF3E9DA),
    page:    Color(0xFF10100F),
    surface: Color(0xFF1C1B19),
    accent:  Color(0xFFC9A46A),
    mist:    Color(0xFF34312D),
    muted:   Color(0xFFA9A097),
    line:    Color(0xFF2D2A26),
  );

  // ────────────────────────────────────────────
  // ThemeExtension boilerplate
  // ────────────────────────────────────────────

  @override
  AppThemeTokens copyWith({
    Color? ink, Color? page, Color? surface,
    Color? accent, Color? mist, Color? muted, Color? line,
  }) => AppThemeTokens(
    ink:     ink     ?? this.ink,
    page:    page    ?? this.page,
    surface: surface ?? this.surface,
    accent:  accent  ?? this.accent,
    mist:    mist    ?? this.mist,
    muted:   muted   ?? this.muted,
    line:    line    ?? this.line,
  );

  @override
  AppThemeTokens lerp(AppThemeTokens? other, double t) {
    if (other == null) return this;
    return AppThemeTokens(
      ink:     Color.lerp(ink,     other.ink,     t)!,
      page:    Color.lerp(page,    other.page,    t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      accent:  Color.lerp(accent,  other.accent,  t)!,
      mist:    Color.lerp(mist,    other.mist,    t)!,
      muted:   Color.lerp(muted,   other.muted,   t)!,
      line:    Color.lerp(line,    other.line,    t)!,
    );
  }
}

/// BuildContext 快捷扩展，Widget 中用 `context.tt` 拿到当前主题 token
extension AppThemeContext on BuildContext {
  AppThemeTokens get tt =>
    Theme.of(this).extension<AppThemeTokens>() ?? AppThemeTokens.softWardrobeLight;
}
