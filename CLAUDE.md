# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Today Wear (今日穿什麼)** - A private outfit diary app built with Flutter. No account, no cloud, no tracking. Designed for users who want to record daily outfits without social features or data collection.

**Target Users**: Taiwan region, 16-30 years old, female-focused design.

## Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run on Android (requires JDK 17/21, not Java 25)
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
flutter run

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

### Bottom Navigation Padding (critical)
The root `Scaffold` uses `extendBody: true` so content flows behind the floating tab bar. All pages must reserve space at the bottom:

```dart
// Scrollable (ListView / CustomScrollView / SingleChildScrollView):
padding: EdgeInsets.only(bottom: 72 + MediaQuery.of(context).padding.bottom)

// Non-scrollable (Column etc.) — add at the very end:
SizedBox(height: 72 + MediaQuery.of(context).padding.bottom)
```

Tab bar = 58px container + 14px bottom padding = 72px total.

### State Management
- MVP stage: `StatefulWidget` + `ValueNotifier`/`ChangeNotifier`
- No Riverpod/Bloc/Redux during MVP
- State logic must not live inside `build()`

### Null Safety
- Prefer `late`/`required` over `!` force unwrap
- Document any `!` usage with a comment

### Navigation
All routes are pushed via `Navigator.push`/`Navigator.pop` — no named routes yet. Do not add string-based routing without discussion.

## Theme Token System

Colors are **not** hardcoded — access them via `context.tt` (a `BuildContext` extension defined in `app_theme_tokens.dart`):

```dart
final tt = context.tt;
color: tt.ink       // primary text / buttons
color: tt.page      // page background
color: tt.surface   // card background
color: tt.accent    // highlights / date boxes
color: tt.mist      // chip / tag backgrounds
color: tt.muted     // secondary text
color: tt.line      // dividers / borders
```

`AppThemeTokens` is a `ThemeExtension` injected via `ThemeData.extensions`. There are **5 presets × 2 modes = 10 token sets** (e.g. `AppThemeTokens.softWardrobeLight`). `ThemeService` (singleton) persists the active preset and mode to `SharedPreferences`.

**Forbidden**: hardcoded hex values in widgets, pure black `#000000`, pure white `#FFFFFF`, neon/gradient colors, shadow opacity > 12%.

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