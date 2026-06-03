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
    required this.accent2,
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
  /// 次级强调色（渐变、天气卡片等）
  final Color accent2;
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
    accent2: Color(0xFF7D9A88),
    mist:    Color(0xFFEFE7DC),
    muted:   Color(0xFF7C746D),
    line:    Color(0xFFE8DDD0),
  );
  static const softWardrobeDark = AppThemeTokens(
    ink:     Color(0xFFF4EFE7),
    page:    Color(0xFF171513),
    surface: Color(0xFF24211E),
    accent:  Color(0xFFD8AA8D),
    accent2: Color(0xFFAFC7B8),
    mist:    Color(0xFF3A332D),
    muted:   Color(0xFFB8AEA4),
    line:    Color(0xFF403A34),
  );

  static const matchaLight = AppThemeTokens(
    ink:     Color(0xFF486554),
    page:    Color(0xFFF7F8F2),
    surface: Color(0xFFFFFFFF),
    accent:  Color(0xFF8AA07B),
    accent2: Color(0xFFC49A6C),
    mist:    Color(0xFFE4EADB),
    muted:   Color(0xFF6F7B70),
    line:    Color(0xFFDDE6D6),
  );
  static const matchaDark = AppThemeTokens(
    ink:     Color(0xFFDDE9DD),
    page:    Color(0xFF121812),
    surface: Color(0xFF20281F),
    accent:  Color(0xFFAFC29F),
    accent2: Color(0xFFD2AF7D),
    mist:    Color(0xFF344034),
    muted:   Color(0xFFAEB9AD),
    line:    Color(0xFF3A4638),
  );

  static const cityBlueLight = AppThemeTokens(
    ink:     Color(0xFF3F68A8),
    page:    Color(0xFFF6F8FB),
    surface: Color(0xFFFFFFFF),
    accent:  Color(0xFF7396BF),
    accent2: Color(0xFFC78363),
    mist:    Color(0xFFE6EDF7),
    muted:   Color(0xFF6E7A8A),
    line:    Color(0xFFDDE6F1),
  );
  static const cityBlueDark = AppThemeTokens(
    ink:     Color(0xFFDCE8FA),
    page:    Color(0xFF111722),
    surface: Color(0xFF1E2633),
    accent:  Color(0xFF9AB7D8),
    accent2: Color(0xFFD8AA8D),
    mist:    Color(0xFF303D50),
    muted:   Color(0xFFAEB8C6),
    line:    Color(0xFF38475C),
  );

  static const roseLight = AppThemeTokens(
    ink:     Color(0xFF7B4B54),
    page:    Color(0xFFFCF6F6),
    surface: Color(0xFFFFFFFF),
    accent:  Color(0xFFD79AA5),
    accent2: Color(0xFFA88A70),
    mist:    Color(0xFFF0DDE1),
    muted:   Color(0xFF806C70),
    line:    Color(0xFFECD8DC),
  );
  static const roseDark = AppThemeTokens(
    ink:     Color(0xFFF5DEE2),
    page:    Color(0xFF1B1315),
    surface: Color(0xFF2A2023),
    accent:  Color(0xFFE0A9B3),
    accent2: Color(0xFFD2B28D),
    mist:    Color(0xFF443036),
    muted:   Color(0xFFC5B0B5),
    line:    Color(0xFF4B363C),
  );

  static const nightGalleryLight = AppThemeTokens(
    ink:     Color(0xFF2B2722),
    page:    Color(0xFFF8F4EC),
    surface: Color(0xFFFFFDF8),
    accent:  Color(0xFFC9A46A),
    accent2: Color(0xFF4F6477),
    mist:    Color(0xFFEFE3D1),
    muted:   Color(0xFF786F64),
    line:    Color(0xFFE3D7C6),
  );
  static const nightGalleryDark = AppThemeTokens(
    ink:     Color(0xFFF3E9DA),
    page:    Color(0xFF10100F),
    surface: Color(0xFF1C1B19),
    accent:  Color(0xFFC9A46A),
    accent2: Color(0xFF8FA9BF),
    mist:    Color(0xFF34312D),
    muted:   Color(0xFFA9A097),
    line:    Color(0xFF393530),
  );

  // ────────────────────────────────────────────
  // ThemeExtension boilerplate
  // ────────────────────────────────────────────

  @override
  AppThemeTokens copyWith({
    Color? ink, Color? page, Color? surface,
    Color? accent, Color? accent2, Color? mist, Color? muted, Color? line,
  }) => AppThemeTokens(
    ink:     ink     ?? this.ink,
    page:    page    ?? this.page,
    surface: surface ?? this.surface,
    accent:  accent  ?? this.accent,
    accent2: accent2 ?? this.accent2,
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
      accent2: Color.lerp(accent2, other.accent2, t)!,
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
