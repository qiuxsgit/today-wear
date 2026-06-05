# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Today Wear (今日穿什麼)** - A private outfit diary app built with Flutter. Offline-first: all data lives on-device (SQLite); an **optional** account enables cloud sync against `today-wear-server`. No social features, no tracking.

**Target Users**: Taiwan region, 16-30 years old, female-focused design.

## Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Debug run with device picker (default iOS; -- passes extra args to flutter run)
./scripts/run_debug.sh [--platform={ios,android}] [-- --dart-define=FOO=bar]

# Run on Android (requires JDK 21, not the system-default Java 25)
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
flutter run

# Android 现在分两个 flavor（channel 维度）：
#   play = Google Play（AAB，不带安装权限）
#   apk  = 直发 APK（应用内更新）
# Android 设备上 flutter run 必须指定 flavor；macOS/iOS 不受影响：
flutter run --flavor play --dart-define=DIST_CHANNEL=play

# 出包：
flutter build appbundle --release --flavor play --dart-define=DIST_CHANNEL=play
flutter build apk      --release --flavor apk  --dart-define=DIST_CHANNEL=apk

# macOS debug window is pre-configured to 390×844 (iPhone proportions) via window_manager

# Generate Drift database code (after modifying tables.dart or daos)
flutter pub run build_runner build

# Clean and regenerate
flutter pub run build_runner build --delete-conflicting-outputs

# Static analysis — must pass with zero warnings/errors/hints before marking any task done
flutter analyze
```

## Architecture

```
lib/
├── main.dart                 # App entry, theme/locale/notification/session init, MainScreen (5-tab nav)
├── api/                      # REST 客户端：ApiClient(信封/Bearer/异常) + auth/user/outfit/tag/media API + GfsUploader
├── database/                 # Drift SQLite database
│   ├── database.dart         # Singleton AppDatabase, schema migrations (schemaVersion=3)
│   ├── tables.dart           # Table definitions (含云同步列 serverId/dirty/serverImageId)
│   └── daos/                 # OutfitDao, TagDao, ImageDao (+ generated .g.dart)
├── models/                   # Outfit, UserProfile, Reminder
├── repositories/             # OutfitRepository, ReminderRepository
├── screens/                  # Page widgets (one per file)
├── widgets/                  # Reusable UI components
├── services/                 # ImageService, LocaleService, ThemeService, NotificationService, ProfileService,
│                             # SessionService(会话), SyncService(云同步引擎), ProfileSync(资料同步)
├── theme/                    # AppThemeTokens, AppSpacing, AppTextStyle, TagColors
└── l10n/                     # i18n (zh, en, ja, ko)
```

### Cloud Sync（可选账号）
离线优先：本地 SQLite 是源真相，未登录全功能可用。登录后 `SyncService` 推送脏数据
（`dirty=1`）/ 拉取远端增量（`since` + `serverId` 映射），冲突 last-write-wins（updatedAt 毫秒）。
图片经 `/media/upload-token` 直传 GFS，拉取时下载到本地按本地文件渲染。API 基地址在
`lib/api/api_config.dart`（默认测试环境，`--dart-define=API_BASE_URL=` 覆盖）。服务端契约见
`today-wear-server/docs/api.md`。

### Data Flow
- **Database**: Drift ORM with SQLite, singleton `AppDatabase`
- **Tables**: `Outfits`, `Tags`, `OutfitTags` (many-to-many), `OutfitImages`
- **Repositories**: `OutfitRepository` wraps DB operations; `ReminderRepository` for local notifications
- **Services**: `ImageService` (image storage/compression), `LocaleService` (i18n), `ThemeService` (theme preset + dark mode), `NotificationService` (local push reminders)

### Navigation
`MainScreen` in `main.dart` hosts a 5-tab `Scaffold` with `extendBody: true`. Tab index 2 (center "add" button) does not swap pages — it pushes `AddOutfitPage` modally. After saving, it calls `NotificationService.rescheduleAll()` and refreshes home data.

## Code Standards

### Naming
- Files: `snake_case.dart`
- Classes/Widgets: `PascalCase`
- Variables/methods: `camelCase`
- Constants: `lowerCamelCase` (never `ALL_CAPS`)

### Structure
- Max 300 lines per file
- One Widget per file
- Named parameters for 3+ arguments
- No hardcoded colors — use `context.tt`
- No magic numbers — use `AppSpacing`
- Use `debugPrint()` not `print()`

<!-- 浮动 Tab 底部安全间距规范详见 .claude/rules/coding/ui.md -->


### State Management
- MVP stage: `StatefulWidget` + `ValueNotifier`/`ChangeNotifier`
- No Riverpod/Bloc/Redux during MVP
- State logic must not live inside `build()`

### Null Safety
- Prefer `late`/`required` over `!` force unwrap
- Document any `!` usage with a comment

### Navigation
All routes are pushed via `Navigator.push`/`Navigator.pop` — no named routes yet. Do not add string-based routing without discussion.

<!-- 主题色 Token（context.tt）使用规范详见 .claude/rules/coding/ui.md -->

## Key Dependencies

- `drift` + `drift_flutter` — SQLite ORM (requires code-gen via `build_runner`)
- `image_picker` — Camera/gallery access
- `flutter_cache_manager` — Image caching
- `reorderable_grid_view` — Draggable grid for image ordering
- `shared_preferences` — Persists locale, theme mode, theme preset
- `intl` + `flutter_localizations` — i18n support
- `flutter_local_notifications` + `timezone` — Local push reminders
- `table_calendar` — Calendar view
- `fl_chart` — Statistics charts
- `window_manager` — macOS debug window sizing
- `url_launcher` — External links / email on contact page

Do not introduce new packages without explaining the reason first.

## AI 协作规范

- 任何任务完成后，需说一句「任务已完成，等待下一步指示」