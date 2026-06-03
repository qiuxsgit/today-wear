# 每日穿搭提醒 — 设计文档

**日期**: 2026-06-03
**状态**: 设计已确认，待实现

---

## 概述

为 Today Wear 添加本地每日提醒功能，用户可以设置多个提醒时段，到达设定时间后系统发送本地通知，提醒用户记录今日穿搭。支持通知栏快捷操作（拍照/选图），无需进入 App 即可快速记录。

**核心理念**：隐私优先 — 纯本地调度，无需账号，不上传任何数据。

---

## 功能需求

### F1: 提醒列表页
- 入口位于 ProfilePage 设置卡片中，标签行 "每日提醒"，右侧显示已开启数量（如 "已开启 2 个"）
- 点击进入 ReminderListPage
- 空状态：引导文案 + 新增按钮
- 每个提醒以卡片形式展示：时间 + 重复星期 + 启用/禁用开关 + 点击进入编辑
- 列表底部或右上角新增按钮

### F2: 新增/编辑提醒页
- 时间选择器：小时 + 分钟，滚轮或数字输入
- 星期多选：周一至周日 Chip 样式，未选中时提醒每天触发
- "当天已记录则跳过" 开关：默认开启，减少打扰
- 编辑模式下显示删除按钮
- 保存后返回列表页并立即调度/更新通知

### F3: 本地通知调度
- 使用 `flutter_local_notifications` 插件
- 按 weekly 重复规则调度：`day=weekday, hour, minute` 组合
- 如果用户选了多天（如周一、周三、周五），则分别为每一天注册一个通知
- 开关关闭时取消对应通知；删除提醒时取消对应通知
- 每个提醒关联一个唯一的 notification id（基于 reminder.id 和 weekday 计算）

### F4: 通知行为
- **通知内容**：标题 "今日穿搭"，正文 "别忘了记录今天的穿搭哦～"
- **Android 通知栏快捷操作**：两个按钮 — "📷 拍照记录"、"🖼 从相册选择"
- **iOS Notification Actions**：同上，两个 action button
- **点击通知本体**：打开 App 并进入新增穿搭页（AddOutfitPage）
- **点击快捷操作**：
  - 拍照 → 打开 AddOutfitPage 并直接触发拍照
  - 选图 → 打开 AddOutfitPage 并直接触发相册选择

### F5: 智能跳过
- 每个提醒可独立配置 "当天已记录则跳过"
- 默认开启
- 通知触发前检查 `OutfitRepository` 中当天是否有记录
- 若有记录则取消本次通知展示

---

## 数据模型

### Reminders 表（Drift）

```dart
class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get hour => integer()();           // 0-23
  IntColumn get minute => integer()();          // 0-59
  TextColumn get weekdays => text()();          // JSON array, 如 "[1,2,3,4,5]", 空数组 "[]" 表示每天
  IntColumn get skipIfRecorded => integer().withDefault(const Constant(1))(); // 0/1, 默认 1
  IntColumn get isEnabled => integer().withDefault(const Constant(1))();      // 0/1, 默认 1
  IntColumn get createdAt => integer()();       // Unix timestamp
}
```

### ReminderRepository

遵循现有 Repository 模式：

```dart
class ReminderRepository {
  final AppDatabase _db;
  
  Future<List<ReminderData>> getAllReminders();
  Future<ReminderData?> getReminder(int id);
  Future<int> insertReminder(RemindersCompanion companion);
  Future<void> updateReminder(int id, RemindersCompanion companion);
  Future<void> deleteReminder(int id);
  Future<int> getEnabledCount();
}
```

---

## 通知 ID 策略

每个 reminder + weekday 组合对应一个 notification id，确保同一提醒的不同星期天可以被独立调度/取消。

```
notificationId = reminderId * 10 + weekdayIndex
// weekdayIndex: Mon=1, Tue=2, ..., Sun=7
// 例如 reminder.id=3, weekday=Monday → notificationId=31
```

这样 reminder.id 最大可达 ~200M（int 上限 / 10），绰绰有余。

---

## 文件结构

```
lib/
├── database/
│   └── tables.dart                    # 新增 Reminders 表
│   └── database.dart                  # 数据库版本升级
│   └── daos/
│       └── reminder_dao.dart          # 新增 DAO
├── repositories/
│   └── reminder_repository.dart       # 新增 Repository
├── services/
│   └── notification_service.dart      # 新增：通知调度与处理
├── screens/
│   └── reminder_list_page.dart        # 新增：提醒列表页
│   └── reminder_edit_page.dart        # 新增：新增/编辑提醒页
└── l10n/                              # 新增 i18n keys
```

---

## 依赖

- `flutter_local_notifications` — 本地通知调度与展示
  - Android: 需要 `AndroidManifest.xml` 权限声明 `RECEIVE_BOOT_COMPLETED`（设备重启后重新调度通知）
  - iOS: 需要 `Info.plist` 请求通知权限

---

## 边界情况

1. **权限未授予**：首次进入列表页时检查通知权限，若未授权则显示引导提示
2. **设备重启**：Android 通过 `RECEIVE_BOOT_COMPLETED` 广播重新注册所有已启用的通知；iOS 通知由系统保留无需额外处理
3. **时区变化**：使用系统当前时区调度，用户旅行时通知时间会跟随系统时间
4. **当天已记录判断**：查询 `Outfits` 表中 `date` 在今天范围内的记录数 > 0
5. **多个提醒同一时间**：允许（每个 reminder 独立 id）
6. **星期变更**：编辑提醒后先取消旧通知再重新调度

---

## 非功能性要求

- 通知调度必须在后台线程执行，不阻塞 UI
- 列表页加载提醒需 < 200ms
- 遵循现有代码规范：`snake_case.dart` 文件名，`PascalCase` 类名，`camelCase` 方法名
- 所有文案走 i18n（zh/en/ja/ko）
- UI 使用 `AppThemeTokens` + `AppSpacing`，禁止硬编码颜色和尺寸
