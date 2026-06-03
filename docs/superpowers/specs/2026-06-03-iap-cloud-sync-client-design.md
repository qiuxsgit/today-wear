# 客户端设计：内购付费 + 云同步

> 状态：设计阶段 | 日期：2026-06-03

## 一、功能概述

在 Flutter App 中接入 Apple IAP 和 Google Play 订阅支付，区分免费和付费用户能力，并实现以服务端为单一数据源的云同步功能。

### 变现三轨

| 角色 | 能力 | 获取方式 |
|------|------|----------|
| 免费用户 | 近 7 天穿搭记录 | 默认 |
| 免费用户 | 全量历史 + 统计报告 + 主题包 | 激励广告 / 签到积分兑换 |
| 付费用户 | 全量功能 + 云同步 | ¥9/月 自动续费订阅 |

---

## 二、技术依赖

```yaml
# pubspec.yaml 新增
dependencies:
  purchases_flutter: ^8.0.0     # RevenueCat - IAP 订阅管理
  google_mobile_ads: ^5.0.0     # AdMob 激励广告
  http: ^1.2.0                   # HTTP 客户端（已有或新增）
  connectivity_plus: ^6.0.0      # 网络状态监听
```

---

## 三、数据流

### 3.1 免费用户（纯本地模式）

```
CRUD 操作 → 本地 SQLite（无网络交互）
展示限制 → 查询时过滤 date >= 7天前
积分/广告 → 前端状态管理 + SharedPreferences
```

### 3.2 付费用户 — 有网络

```
CRUD 操作
  ├──→ REST API 写入服务端
  │     └── 返回 serverId + serverTagId + serverImageId
  └──→ 本地 SQLite（写入并填充 serverId，isSynced=1）
```

### 3.3 付费用户 — 无网络

```
CRUD 操作
  └──→ 本地 SQLite（serverId=null，isSynced=0）

网络恢复时：
  SyncService.pushUnsyncedData()
    ├── 扫描 isSynced=0 的记录
    ├── 逐条 POST/PUT 到服务端
    │   ├── 成功 → 回填 serverId，isSynced=1
    │   └── 失败 → 保持标记，下次重试
    └── 同步完成后通知 UI 刷新
```

### 3.4 首次订阅开通

```
用户完成订阅
  → RevenueCat 回调 → 本地设置 isPremium=true
  → SyncService.fullUploadOnFirstSubscribe()
    ├── 全量上传本地数据到服务端
    └── 回填所有 serverId
  → 后续所有操作走服务端模式
```

### 3.5 订阅过期

```
RevenueCat 回调 → isPremium=false
  → 后续操作退回纯本地模式
  → 本地数据不受影响
  → 重新订阅后全量同步（服务端数据覆盖本地）
```

---

## 四、本地表结构变更

### 4.1 outfits 表

```dart
class Outfits extends Table {
  IntColumn get id => integer().autoIncrement()();       // 本地主键
  IntColumn get serverId => integer().nullable()();       // 新增：服务端 ID
  IntColumn get isSynced => integer().withDefault(const Constant(1))(); // 新增：0=待同步
  IntColumn get date => integer()();
  TextColumn get description => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}
```

### 4.2 tags 表

```dart
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serverId => integer().nullable()();       // 新增
  IntColumn get isSynced => integer().withDefault(const Constant(1))(); // 新增
  TextColumn get name => text().unique()();
  TextColumn get color => text().nullable().withDefault(const Constant('#E8F5E9'))();
}
```

### 4.3 outfit_tags 表

```dart
class OutfitTags extends Table {
  IntColumn get outfitId => integer()();   // 本地 outfit id
  IntColumn get tagId => integer()();      // 本地 tag id
  IntColumn get serverId => integer().nullable()();  // 新增
  IntColumn get isSynced => integer().withDefault(const Constant(1))(); // 新增
}
```

### 4.4 outfit_images 表

```dart
class OutfitImages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serverId => integer().nullable()();        // 新增
  IntColumn get isSynced => integer().withDefault(const Constant(1))(); // 新增
  IntColumn get outfitId => integer()();
  TextColumn get imagePath => text()();       // 本地路径
  TextColumn get ossUrl => text().nullable()(); // 新增：OSS 远程 URL
  IntColumn get displayOrder => integer()();
}
```

---

## 五、新增服务模块

### 5.1 SyncService

```
lib/services/sync_service.dart
```

**职责**：管理本地与服务端数据的同步

```
class SyncService:
  /// 初始化，注册网络监听
  init()

  /// 推送所有未同步数据到服务端
  /// 返回：成功/失败数量
  pushUnsyncedData() → Future<SyncResult>

  /// 首次订阅时全量上传
  fullUploadOnFirstSubscribe() → Future<void>

  /// 从服务端全量拉取覆盖本地
  pullFromServer() → Future<void>

  /// 网络状态变化回调
  _onNetworkChange(connectivityResult)

  /// 开始监听网络状态
  startNetworkMonitor()

  /// 停止监听
  stopNetworkMonitor()
```

**同步顺序**（有依赖关系）：
1. Tags（先同步，outfit 依赖 tagId）
2. Outfits
3. OutfitTags（依赖前两者映射）
4. OutfitImages（依赖 outfitId）

### 5.2 SubscriptionService

```
lib/services/subscription_service.dart
```

**职责**：封装 RevenueCat 操作，提供订阅状态

```
class SubscriptionService:
  /// 初始化 RevenueCat
  init()

  /// 当前是否为付费用户
  isPremium() → bool

  /// 获取订阅产品列表
  getProducts() → Future<List<Package>>

  /// 发起购买
  purchase(package) → Future<CustomerInfo>

  /// 恢复购买
  restorePurchases() → Future<CustomerInfo>

  /// 监听订阅状态变化
  onCustomerInfoChanged → Stream<CustomerInfo>
```

### 5.3 AdService

```
lib/services/ad_service.dart
```

**职责**：激励广告管理

```
class AdService:
  /// 初始化 AdMob
  init()

  /// 加载激励视频广告
  loadRewardedAd()

  /// 展示激励广告
  /// 成功回调 → 发放奖励
  showRewardedAd(onRewarded)

  /// 广告是否可用
  isAdReady() → bool
```

### 5.4 CheckInService

```
lib/services/checkin_service.dart
```

**职责**：每日签到和积分管理

```
class CheckInService:
  /// 今日是否已签到
  hasCheckedInToday() → bool

  /// 执行签到
  /// 返回：连续签到天数、获得积分数
  checkIn() → Future<CheckInResult>

  /// 当前积分余额
  getBalance() → int

  /// 消耗积分
  spend(amount, reason) → Future<bool>

  /// 连续签到天数
  getStreak() → int
```

积分存储在 SharedPreferences 中（简单场景无需服务端）。

### 5.5 ApiClient

```
lib/services/api_client.dart
```

**职责**：封装所有服务端 REST API 调用

```
class ApiClient:
  // Auth
  register(email, password) → Future<AuthResult>
  login(email, password) → Future<AuthResult>
  refreshToken()

  // Outfits
  createOutfit(data) → Future<ServerOutfit>
  updateOutfit(id, data) → Future<ServerOutfit>
  deleteOutfit(id) → Future<void>
  getOutfits(cursor, limit) → Future<OutfitPage>

  // Tags
  createTag(name, color) → Future<ServerTag>
  getTags() → Future<List<ServerTag>>

  // Images
  uploadImage(file) → Future<ImageUploadResult>
  getOssUploadToken() → Future<OssToken>

  // Sync
  batchUpload(data) → Future<BatchResult>
  getSyncStatus() → Future<SyncStatus>
```

---

## 六、Repository 层变更

### OutfitRepository 改为双模式

```dart
class OutfitRepository {
  final SubscriptionService _subscriptionService;
  final ApiClient _apiClient;
  final AppDatabase _db;

  Future<int> saveOutfit(Outfit outfit, {List<File>? imageFiles}) async {
    if (_subscriptionService.isPremium()) {
      // 付费用户：先写服务端，再写本地
      final serverResult = await _apiClient.createOutfit(data);
      // 本地写入并填充 serverId
      return await _saveLocal(serverResult.serverId);
    } else {
      // 免费用户：纯本地
      return await _saveLocal(null);
    }
  }

  Future<List<Outfit>> getAllOutfits({int? limit, int? offset}) async {
    if (_subscriptionService.isPremium()) {
      // 付费：从本地缓存读取（本地已是最新）
      return await _loadLocal(limit, offset);
    } else {
      // 免费：本地读取，且只返回 7 天内
      final sevenDaysAgo = DateTime.now().subtract(Duration(days: 7));
      return await _loadLocal(limit, offset, minDate: sevenDaysAgo);
    }
  }
}
```

---

## 七、UI 变更

### 7.1 ProfilePage 新增入口

- **订阅管理行**：显示订阅状态（免费/已订阅/已过期），点击进入订阅页
- **云同步设置行**（仅付费用户可见）：同步状态、手动触发同步

### 7.2 新增页面

| 页面 | 路径 | 说明 |
|------|------|------|
| `SubscriptionPage` | `lib/screens/subscription_page.dart` | 订阅购买页，展示功能对比、价格、购买按钮 |
| `CloudSyncPage` | `lib/screens/cloud_sync_page.dart` | 同步状态、手动同步按钮、上次同步时间 |
| `AuthPage` | `lib/screens/auth_page.dart` | 邮箱注册/登录（开通云同步时触发） |

### 7.3 首页变更

- 免费用户在列表底部看到「查看更多，需要订阅或看广告」提示卡片
- 付费用户无限制

---

## 八、错误处理

| 场景 | 处理方式 |
|------|----------|
| 写入 API 失败（网络超时） | 标记 isSynced=0，提示用户数据已本地保存 |
| 订阅验证失败 | 降级为免费用户权限 |
| 批量同步中单条失败 | 跳过该条，继续同步其余，记录失败条目 |
| 首次全量上传失败 | 保持 isSynced 标记，下次网络恢复时重试 |
| Token 过期 | 自动 refresh，失败则重新登录 |
| OSS 上传失败 | 重试 3 次，仍失败标记图片待同步 |

---

## 九、安全设计

- 用户密码 `bcrypt` 加盐哈希存储
- JWT access token 15 分钟过期 + refresh token 7 天
- API 请求 HTTPS 强制
- OSS 使用 STS 临时凭证直传，不经过服务器中转
- 本地 token 存储使用 `flutter_secure_storage`
