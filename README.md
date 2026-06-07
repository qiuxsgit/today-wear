# 今日穿什麼

> [English](README.en.md)

一款专注于**个人穿搭记录**的轻量 App。不做社交、不做推荐、不收集数据，只帮你记住每天穿了什么。

支持可选账号登录，登录后开启多设备云同步；不登录同样完全可用，数据本地离线保存。

---

## 下载

| 平台 | 链接 |
|------|------|
| iOS (App Store) | Coming Soon |
| Android (Google Play) | Coming Soon |

---

## 功能

- 用照片记录每日穿搭
- 按日期查看穿搭历史
- 为穿搭添加标签与备注
- 数据离线存储，完全不依赖网络
- 可选账号登录，开启多设备同步
- 穿搭提醒通知
- 统计视图（日历 / 图表）
- 支持中文、English、日本語、한국어

---

## 技术栈

| 层级 | 技术 |
|------|------|
| UI 框架 | Flutter 3.x / Dart 3.x · Material 3 |
| 本地存储 | Drift ORM (SQLite) |
| 云同步 | REST API（today-wear-server） |
| 图片 | GFS 直传，本地缓存渲染 |
| 通知 | flutter\_local\_notifications |
| 国际化 | flutter\_localizations (zh / en / ja / ko) |

---

## 平台支持

| 平台 | 说明 |
|------|------|
| iOS | 对外正式发布 |
| Android | 对外正式发布（Google Play / 直发 APK 双渠道） |
| macOS | 仅调试构建，不对外发布 |

---

## 本地开发

### 环境要求

- Flutter 3.x
- Dart 3.x
- Xcode（iOS 构建）
- Android Studio + JDK 21（Android 构建）

### 安装依赖

```bash
flutter pub get
```

### 运行

```bash
# iOS / macOS（默认）
flutter run

# Android（需指定 flavor）
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
flutter run --flavor play --dart-define=DIST_CHANNEL=play
```

### 构建发布包

```bash
# Android AAB（Google Play）
flutter build appbundle --release --flavor play --dart-define=DIST_CHANNEL=play

# Android APK（直发）
flutter build apk --release --flavor apk --dart-define=DIST_CHANNEL=apk
```

### 代码生成（修改数据库 schema 后执行）

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 许可证

本项目采用 **Today Wear Personal & Commercial License**。

- 个人及非商业用途免费
- 商业用途需购买授权

详见 [LICENSE](LICENSE) 文件。如需商业授权，请联系：qiuxs@qiuxs.com

---

## 维护者

**qiuxs** — 独立开发者

- 邮箱：qiuxs@qiuxs.com
- 问题反馈：[GitHub Issues](../../issues)
