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

# Generate Drift database code (after modifying tables.dart)
flutter pub run build_runner build

# Clean and regenerate
flutter pub run build_runner build --delete-conflicting-outputs
```

## Architecture

```
lib/
├── main.dart                 # App entry, MaterialApp config
├── database/                 # Drift SQLite database
│   ├── database.dart         # DB connection, migration
│   ├── tables.dart           # Table definitions
│   └── daos/                 # Data Access Objects
├── models/                   # Data models (Outfit, UserProfile)
├── repositories/             # Data layer abstraction
├── screens/                  # Page widgets
├── widgets/                  # Reusable UI components
├── services/                 # Business logic (ImageService, LocaleService)
├── theme/                    # AppColors, AppSpacing, AppTextStyle
└── l10n/                     # i18n (zh, en, ja, ko)
```

### Data Flow
- **Database**: Drift ORM with SQLite, singleton `AppDatabase`
- **Tables**: `Outfits`, `Tags`, `OutfitTags` (many-to-many), `OutfitImages`
- **Repository**: `OutfitRepository` wraps all DB operations
- **Services**: `ImageService` handles image storage/compression, `LocaleService` for i18n

## Code Standards (from .cursor/rules/)

### Naming
- Files: `snake_case.dart`
- Classes/Widgets: `PascalCase`
- Variables/methods: `camelCase`
- Constants: `lowerCamelCase` (never `ALL_CAPS`)

### Structure
- Max 300 lines per file
- One Widget per file
- Named parameters for 3+ arguments
- No hardcoded colors - use `AppColors`
- No magic numbers - use `AppSpacing`
- Use `debugPrint()` not `print()`

### State Management
- MVP stage: `StatefulWidget` + `ValueNotifier`/`ChangeNotifier`
- No Riverpod/Bloc/Redux during MVP

### Null Safety
- Prefer `late`/`required` over `!` force unwrap
- Document any `!` usage

## Color System

All colors defined in `lib/theme/app_colors.dart`:

| Name | Hex | Usage |
|------|-----|-------|
| `primary` | #1A1A1A | Buttons, selected state, brand |
| `bgPrimary` | #FAFAFA | Page background |
| `bgSecondary` | #F5F5F5 | Cards, list items |
| `textPrimary` | #2F2F2F | Titles, important text |
| `textSecondary` | #7A7A7A | Descriptions, timestamps |
| `success` | #8FAE9E | Success feedback |
| `warning` | #D6A77A | Warnings |
| `error` | #C97C7C | Errors, delete |

**Forbidden**: #000000, #FFFFFF, neon colors, gradients, shadows > 12% opacity.

## Key Dependencies

- `drift` + `drift_flutter` - SQLite ORM
- `image_picker` - Camera/gallery access
- `flutter_cache_manager` - Image caching
- `reorderable_grid_view` - Draggable grid for image ordering
- `shared_preferences` - Simple key-value storage
- `intl` + `flutter_localizations` - i18n support

## AI 协作规范

- 任何任务完成后，需说一句「任务已完成，等待下一步指示」