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
