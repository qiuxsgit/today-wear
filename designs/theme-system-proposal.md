# 今日穿什麼 Theme System Proposal

## 设计目标

主题切换不只是浅色/深色，而是让用户选择“今天想用什么气质记录穿搭”。主题应该改变品牌色、页面背景、卡片、标签与关键操作，但不改变信息架构。

## 推荐首发主题

### 1. Soft Wardrobe

默认主题。温柔、干净、带一点衣橱杂志感，适合大多数用户。

| Token | Light | Dark |
| --- | --- | --- |
| primary | `#25221F` | `#F4EFE7` |
| accent | `#C78363` | `#D8AA8D` |
| background | `#FBF8F3` | `#171513` |
| surface | `#FFFDF9` | `#24211E` |
| surfaceAlt | `#F4EFE7` | `#302B27` |
| textPrimary | `#25221F` | `#F4EFE7` |
| textSecondary | `#7C746D` | `#B8AEA4` |
| tagBg | `#EFE7DC` | `#3A332D` |

### 2. Matcha Minimal

清爽、自然、日常感强，适合偏通勤、干净穿搭记录。

| Token | Light | Dark |
| --- | --- | --- |
| primary | `#486554` | `#DDE9DD` |
| accent | `#8AA07B` | `#AFC29F` |
| background | `#F7F8F2` | `#121812` |
| surface | `#FFFFFF` | `#20281F` |
| surfaceAlt | `#E8EDE2` | `#2C372B` |
| textPrimary | `#243029` | `#EFF5EA` |
| textSecondary | `#6F7B70` | `#AEB9AD` |
| tagBg | `#E4EADB` | `#344034` |

### 3. City Blue

更现代、利落，适合日历、统计、效率型记录场景。

| Token | Light | Dark |
| --- | --- | --- |
| primary | `#3F68A8` | `#DCE8FA` |
| accent | `#7396BF` | `#9AB7D8` |
| background | `#F6F8FB` | `#111722` |
| surface | `#FFFFFF` | `#1E2633` |
| surfaceAlt | `#E8EEF6` | `#2B3545` |
| textPrimary | `#202A38` | `#EDF3FA` |
| textSecondary | `#6E7A8A` | `#AEB8C6` |
| tagBg | `#E6EDF7` | `#303D50` |

### 4. Rose Editorial

偏女性化但不甜腻，适合想要“漂亮一点”的默认备选主题。

| Token | Light | Dark |
| --- | --- | --- |
| primary | `#7B4B54` | `#F5DEE2` |
| accent | `#D79AA5` | `#E0A9B3` |
| background | `#FCF6F6` | `#1B1315` |
| surface | `#FFFFFF` | `#2A2023` |
| surfaceAlt | `#F5E7E9` | `#3A2A2E` |
| textPrimary | `#302225` | `#F8ECEE` |
| textSecondary | `#806C70` | `#C5B0B5` |
| tagBg | `#F0DDE1` | `#443036` |

### 5. Night Gallery

真正的深色主题，不只是反色。适合夜间使用、图片浏览和沉浸式回顾。

| Token | Dark |
| --- | --- |
| primary | `#F3E9DA` |
| accent | `#C9A46A` |
| background | `#10100F` |
| surface | `#1C1B19` |
| surfaceAlt | `#292724` |
| textPrimary | `#F3E9DA` |
| textSecondary | `#A9A097` |
| tagBg | `#34312D` |

## 主题切换交互

- 设置页入口：`外观主题`
- 一级选择：主题色盘，例如 Soft Wardrobe / Matcha Minimal / City Blue / Rose Editorial / Night Gallery
- 二级选择：显示模式，跟随系统 / 浅色 / 深色
- 预览方式：每个主题卡片显示 3 个色块、一个迷你穿搭卡、主题名称
- 保存策略：主题色盘和显示模式分别保存，避免用户换主题时丢失浅深色偏好

## Flutter 落地建议

新增一个 `AppThemePreset` enum，与现有 `ThemeModeType` 分开：

```dart
enum AppThemePreset {
  softWardrobe,
  matchaMinimal,
  cityBlue,
  roseEditorial,
  nightGallery,
}
```

新增 `AppThemeTokens`，集中管理主题 token。现有 `AppColors.primary` 这类静态颜色可以先保留，但新页面优先从 `Theme.of(context).extension<AppThemeTokens>()` 读取。

```dart
@immutable
class AppThemeTokens extends ThemeExtension<AppThemeTokens> {
  final Color accent;
  final Color surfaceAlt;
  final Color tagBg;
  final Color imagePlaceholder;

  const AppThemeTokens({
    required this.accent,
    required this.surfaceAlt,
    required this.tagBg,
    required this.imagePlaceholder,
  });
}
```

这样可以先在设置页、底部导航、新增页、首页卡片逐步迁移，不需要一次性重写全局 UI。
