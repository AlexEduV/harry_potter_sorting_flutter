# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run the app
flutter run

# Analyze
flutter analyze --no-pub

# Run all tests
flutter test

# Run a single test file
flutter test test/domain/entities/character_entity_test.dart

# Regenerate code (Drift, Retrofit, AutoRoute, json_serializable)
dart run build_runner build --delete-conflicting-outputs
```

> Always run `build_runner` after changing any file annotated with `@JsonSerializable`, `@RestApi`, `@DriftDatabase`, or `@AutoRouterConfig`.

## Architecture

Clean Architecture with three layers: **Presentation → Domain → Data**.

### Dependency Injection

`GetIt` is the service locator. All wiring lives in `lib/core/di/dependency_injection.dart`. Singletons (Dio, AppDatabase, CharacterApiService) are registered eagerly; repositories, use cases, and mappers are lazy singletons. Notifiers are **not** registered in GetIt — they are provided via `MultiProvider` in `main.dart`.

### State Management

`Provider` + `ChangeNotifier`. Each page has its own `notifiers/` subdirectory. Notifiers that need repositories or use cases receive them via GetIt at construction time (passed through the `MultiProvider` in `main.dart`).

### Routing

`AutoRoute` with generated code in `lib/router/router.gr.dart`. Two routes: `/` (home with bottom nav) and `/details/:name`. After changing route definitions in `lib/router/router.dart`, run `build_runner`.

### Data Layer

- **Network:** `Dio` + `Retrofit` (`CharacterApiService`). DTOs live in `lib/data/dto/` and use `json_serializable` with `createToJson: false` (read-only from API).
- **Local:** `Drift` SQL database (`AppDatabase`). Schema is in `lib/data/database/database_schema.dart`. The database is accessed via `DatabaseProvider.getDatabase()` as a singleton.
- **Repository:** `CharacterRepositoryImpl` orchestrates API → local storage. On first load it fetches from network and caches locally; subsequent loads read from Drift.

### Domain Layer

- `House` enum (`lib/domain/entities/house.dart`) is the source of truth for house names, image assets, and display strings. Use `House.fromString()` when parsing from the DB or API (both store the string form).
- `CharacterEntity.house` is typed as `House`. When writing to Drift, serialize back via `house.displayName`.
- Use cases: `GetCharactersUseCase`, `ResetCharacterStatsUseCase`.

### Code Generation

Generated files (`*.g.dart`, `*.gr.dart`) are excluded from analysis in `analysis_options.yaml`. Do not manually edit them.
