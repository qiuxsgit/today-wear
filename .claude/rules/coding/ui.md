# UI 规范

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
