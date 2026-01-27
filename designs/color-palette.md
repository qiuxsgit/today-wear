# Today Wear 配色方案设计规范

## 目标用户
16～30岁台湾、日本、韩国女性用户

## 设计理念
- **柔和优雅**：使用低饱和度、高亮度的柔和色调
- **温暖治愈**：营造温暖、舒适的视觉体验
- **简约精致**：避免复杂色彩组合，保持设计的简洁性
- **少女感**：融入粉色、浅紫色等具有青春活力的色彩

## 配色方案

### 1. 主色调系统 (Primary Colors)

#### 品牌主色
```dart
// 柔和樱花粉 - 代表温柔与优雅
primary: Color(0xFFF8BBD0),  // #F8BBD0 (淡粉)
```

#### 辅助色 (Accent Colors)
```dart
// 柔和薰衣草紫 - 增添浪漫感
secondary: Color(0xFFE1BEE7),  // #E1BEE7 (淡紫)

// 清新薄荷绿 - 带来清新感
tertiary: Color(0xFFC8E6C9),  // #C8E6C9 (淡绿)

// 温暖米色 - 营造温馨感
neutral: Color(0xFFF5F0E1),  // #F5F0E1 (米色)
```

### 2. 背景色系统 (Background Colors)

#### 页面背景
```dart
// 纯白背景 - 简洁干净
bgPrimary: Color(0xFFFFFFFF),  // #FFFFFF

// 浅灰背景 - 柔和层次
bgSecondary: Color(0xFFFAFAFA),  // #FAFAFA

// 极浅粉色 - 增添温暖感
bgTertiary: Color(0xFFFDF4F6),  // #FDF4F6 (浅粉白)
```

### 3. 文字色系统 (Text Colors)

#### 主文字
```dart
// 深灰色 - 高对比度，易读性好
textPrimary: Color(0xFF2C2C2C),  // #2C2C2C

// 中灰色 - 次要信息
textSecondary: Color(0xFF757575),  // #757575

// 浅灰色 - 辅助信息
textPlaceholder: Color(0xFFBDBDBD),  // #BDBDBD
```

### 4. 状态颜色系统 (State Colors)

#### 成功状态
```dart
// 柔和绿色 - 正向反馈
success: Color(0xFFA5D6A7),  // #A5D6A7 (浅绿)
```

#### 警告状态
```dart
// 柔和黄色 - 提醒注意
warning: Color(0xFFFFF9C4),  // #FFF9C4 (浅黄)
```

#### 错误状态
```dart
// 柔和红色 - 错误提示
error: Color(0xFFE57373),  // #E57373 (浅红)
```

### 5. 特殊颜色系统

#### 时间线颜色
```dart
// 柔和蓝色 - 时间轴线条
timelineLine: Color(0xFFE3F2FD),  // #E3F2FD (浅蓝)

// 柔和紫色 - 时间轴圆点
timelineDot: Color(0xFFCE93D8),  // #CE93D8 (浅紫)
```

#### 图片占位色
```dart
// 极浅灰色 - 图片加载占位
imagePlaceholder: Color(0xFFF5F5F5),  // #F5F5F5
```

### 6. 色彩使用规范

#### 整体风格
- 主色调使用频率：≤ 30%
- 辅助色使用频率：≤ 20%
- 背景色使用频率：≥ 50%
- 文字色使用频率：根据内容层级调整

#### 排版规范
- 主标题：textPrimary，18-24px
- 副标题：textSecondary，14-16px
- 正文：textSecondary，12-14px
- 辅助文字：textPlaceholder，10-12px

#### 交互规范
- 按钮：主色背景 + 白色文字
- 卡片：白色背景 + 浅阴影
- 输入框：浅灰背景 + 中灰边框
- 分割线：极浅灰色

### 7. 适配建议

#### 深色模式
- 背景色：深灰到黑色渐变
- 文字色：浅灰到白色
- 主色调：保持柔和粉色调，但调整亮度和饱和度
- 确保对比度符合 WCAG 2.0 AA 级标准

#### 无障碍设计
- 文字与背景对比度 ≥ 4.5:1
- 避免使用过于相似的颜色组合
- 重要信息使用高对比度颜色

### 8. 设计工具支持

#### Figma 样式库
- 配色方案已添加到 designs 文件夹中
- 使用 `today-wear-color-palette.fig` 文件
- 包含完整的颜色变量和使用示例

## 版本历史

### v2.0 (2026-01-27)
- 重新设计针对台湾、日本、韩国年轻女性用户的配色方案
- 增加了柔和粉色、浅紫色和米色系列
- 优化了色彩对比度和可读性
- 添加了完整的设计规范文档

### v1.0 (2026-01-26)
- 初始配色方案
- 使用深色主题和简约色彩
