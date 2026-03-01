# 第二阶段功能实现计划

**开始日期：** 2026-02-27  
**阶段目标：** 用户体验提升 - 日历视图、统计功能、深色模式、搜索优化

---

## 📋 功能清单

### 1. 深色模式 (Dark Mode)
**优先级：** 🔥 高（基础功能，影响所有页面）

#### 实现内容
- [ ] 扩展 `AppColors` 支持深色主题
- [ ] 添加 `ThemeService` 管理主题切换
- [ ] 在设置页添加深色模式开关
- [ ] 适配所有页面到深色模式
- [ ] 支持跟随系统自动切换
- [ ] 主题切换动画

#### 技术方案
- 使用 Flutter 内置的 `ThemeMode`
- `SharedPreferences` 存储用户偏好
- `AppColors` 扩展 dark 版本颜色
- 所有颜色引用改为从主题获取

#### 文件变更
- `lib/theme/app_colors.dart` - 添加深色颜色
- `lib/services/theme_service.dart` - 新建主题服务
- `lib/main.dart` - 集成主题切换
- `lib/screens/profile_page.dart` - 添加设置入口
- `lib/screens/settings_page.dart` - 新建设置页（或复用 profile）
- 所有页面适配深色模式

---

### 2. 日历视图 (Calendar View)
**优先级：** 🔥 高（用户核心需求）

#### 实现内容
- [ ] 设计日历 UI 布局
- [ ] 实现月历视图组件
- [ ] 显示每日穿搭状态（有/无记录）
- [ ] 点击日期跳转详情或添加
- [ ] 支持月份切换
- [ ] 今天标记高亮
- [ ] 月度统计摘要

#### 技术方案
- 使用 `table_calendar` 包或自定义实现
- 从数据库查询每月穿搭记录
- 日历格子显示穿搭缩略图或标记
- 点击事件路由到详情/添加页

#### 文件变更
- `lib/screens/calendar_page.dart` - 新建日历页
- `lib/widgets/calendar_widget.dart` - 新建日历组件
- `lib/repositories/outfit_repository.dart` - 添加月度查询方法
- `lib/widgets/main_navigation.dart` - 添加日历 Tab（可选）

---

### 3. 统计功能 (Statistics)
**优先级：** 📌 中高

#### 实现内容
- [ ] 统计页面框架
- [ ] 月度穿搭数量卡片
- [ ] 标签使用频率统计
- [ ] 周/月趋势图（简单柱状图）
- [ ] 最常穿搭配标签
- [ ] 月度穿搭日历热力图

#### 技术方案
- 从数据库聚合查询统计数据
- 使用 `fl_chart` 绘制简单图表
- 按月份/周分组统计
- 标签使用频率排序

#### 文件变更
- `lib/screens/statistics_page.dart` - 新建统计页
- `lib/widgets/statistics_card.dart` - 统计卡片组件
- `lib/widgets/chart_widget.dart` - 图表组件
- `lib/repositories/outfit_repository.dart` - 添加统计查询方法

---

### 4. 搜索与筛选优化 (Search & Filter)
**优先级：** 📌 中

#### 实现内容
- [ ] 搜索页面 UI
- [ ] 多条件筛选（日期范围、标签组合）
- [ ] 搜索结果高亮
- [ ] 搜索历史（本地存储）
- [ ] 快速筛选标签 chips
- [ ] 清空筛选条件

#### 技术方案
- 扩展现有搜索功能
- `SharedPreferences` 存储搜索历史
- 标签 chips 快速筛选
- 日期范围选择器

#### 文件变更
- `lib/screens/search_page.dart` - 新建或优化搜索页
- `lib/widgets/filter_chips.dart` - 筛选组件
- `lib/repositories/outfit_repository.dart` - 优化搜索方法

---

## 📅 实现顺序

### 第一周：深色模式
1. Day 1-2: 扩展 AppColors，创建 ThemeService
2. Day 3-4: 适配所有页面到深色模式
3. Day 5: 添加设置开关，测试

### 第二周：日历视图
1. Day 1-2: 设计日历 UI，实现基础组件
2. Day 3-4: 集成数据库查询，实现交互
3. Day 5: 优化体验，测试

### 第三周：统计功能
1. Day 1-2: 实现统计查询方法
2. Day 3-4: 创建统计页面和图表
3. Day 5: 优化展示，测试

### 第四周：搜索优化 + 整合测试
1. Day 1-2: 搜索筛选功能开发
2. Day 3-4: 整体测试，Bug 修复
3. Day 5: 文档更新，准备发布

---

## 📦 新增依赖

**pubspec.yaml**
```yaml
dependencies:
  # 日历视图
  table_calendar: ^3.0.9
  
  # 图表
  fl_chart: ^0.66.0
  
  # 主题切换（已内置在 Flutter 中）
```

---

## 🎯 验收标准

### 深色模式
- [ ] 开关切换立即生效
- [ ] 所有页面颜色正确适配
- [ ] 重启后记住用户选择
- [ ] 跟随系统选项正常工作

### 日历视图
- [ ] 正确显示每月天数
- [ ] 有穿搭的日期显示标记
- [ ] 点击日期正确跳转
- [ ] 月份切换流畅
- [ ] 今天高亮显示

### 统计功能
- [ ] 月度数量统计准确
- [ ] 标签频率排序正确
- [ ] 图表显示正常
- [ ] 数据更新及时

### 搜索优化
- [ ] 多条件筛选生效
- [ ] 搜索历史保存
- [ ] 搜索结果准确
- [ ] 清空筛选有效

---

## 📝 提交记录

- [ ] feat: 实现深色模式支持
- [ ] feat: 添加日历视图功能
- [ ] feat: 实现统计功能
- [ ] feat: 优化搜索与筛选
- [ ] docs: 更新第二阶段实现报告

---

**维护者：** 爪子 🐾  
**最后更新：** 2026-02-27
