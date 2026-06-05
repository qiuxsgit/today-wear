# UI 规范

## [重要] 用户可见文案必须国际化

所有用户可见文案（页面文本、Toast、错误提示、对话框、按钮）一律走 l10n
（`AppLocalizations`，zh/en/ja/ko 四语言），禁止硬编码任何单一语言字符串。

✅ 正确：
```dart
AppToast.warning(l10n.authEmailInvalid);
```

❌ 错误：
```dart
AppToast.warning('请输入有效的邮箱地址');
```

- 新增文案 key 必须同步补齐 `lib/l10n/` 全部语言文件，缺语言视为任务未完成。
- Service 层无 BuildContext 时返回错误码/枚举，由 UI 层映射 l10n 文案，
  不得在 Service 内硬编码提示字符串。

## [重要] 浮动 Tab 底部安全间距

根 Scaffold 设置了 `extendBody: true`，页面内容会延伸到浮动 Tab 下方。
所有页面的可滚动内容底部或最后一个子元素后必须预留间距：

✅ ListView / CustomScrollView / SingleChildScrollView：
```dart
padding: EdgeInsets.only(
  bottom: 72 + MediaQuery.of(context).padding.bottom,
)
```

✅ 非滚动页面（Column 等），在末尾添加：
```dart
SizedBox(height: 72 + MediaQuery.of(context).padding.bottom)
```

❌ 不得省略底部间距，否则最后一项内容被 Tab 遮挡。

计算依据：Tab 容器高 58px + 底部 padding 14px = 72px。

## [重要] 主题色 Token（context.tt）

颜色一律通过 `context.tt`（`app_theme_tokens.dart` 中的 BuildContext 扩展）获取：

✅ 正确：
```dart
final tt = context.tt;
color: tt.ink       // 主文本 / 按钮
color: tt.page      // 页面背景
color: tt.surface   // 卡片背景
color: tt.accent    // 高亮 / 日期块
color: tt.mist      // chip / 标签背景
color: tt.muted     // 次要文本
color: tt.line      // 分割线 / 边框
```

❌ 禁止：widget 内硬编码 hex 色值、纯黑 `#000000`、纯白 `#FFFFFF`、
霓虹/渐变色、阴影透明度 > 12%。

`AppThemeTokens` 是经 `ThemeData.extensions` 注入的 `ThemeExtension`，
共 5 预设 × 2 模式 = 10 套 token（如 `AppThemeTokens.softWardrobeLight`）；
`ThemeService`（单例）将当前预设与模式持久化到 SharedPreferences。

## Toast 统一封装

全局提示一律走 `AppToast`（`widgets/app_toast.dart`），显示位置为屏幕中央
（`ToastGravity.CENTER`），Android / iOS 表现一致。

✅ 正确：
```dart
AppToast.success(l10n.saveSuccess);
```

❌ 禁止：
- 直接调用 `Fluttertoast.showToast` 或 `ScaffoldMessenger.showSnackBar`
- 改用 `ToastGravity.TOP`（会遮挡标题栏）
