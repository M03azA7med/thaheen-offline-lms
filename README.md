# Thaheen Mini Offline LMS (شاهين - العلوم الصحية)

A production-quality, offline-first Arabic health-sciences learning management system (LMS) built with Flutter following Clean Architecture, SOLID principles, and Cubit state management.

---

## Overview

Thaheen is an Arabic-first educational platform designed for health-science students. This application works **100% offline** with bundled course metadata and local MP4 videos.

Key Capabilities:
* **Courses Overview**: Browse offline health science courses with dynamic completion percentages and active lesson resume cards.
* **Course Structure**: View sections and lessons with clear status indicators (لم يبدأ, قيد المشاهدة, مكتمل, مقفل).
* **Sequential Lesson Unlocking**: First lesson is unlocked; every next lesson unlocks across sections only after completing the previous lesson.
* **Video Playback & Controls**: Play local bundled MP4 videos with custom controls, playback speed selector (1x, 1.25x, 1.5x, 2x), seeking, and orientation-aware fullscreen mode.
* **Auto-Completion & Resume**: Automatically marks lessons as completed when reaching 90% progress (`position / duration >= 0.90`), persisting positions to resume upon app restart.
* **Arabic RTL UX**: Native Right-To-Left directionality and Material 3 design system styling tailored for health sciences.

---

## Architecture

The project follows a **Lightweight Clean Architecture**:

```text
Presentation Layer (UI + Cubits)
         ↓
  Domain Layer (Entities + Use Cases + Repository Interfaces)
         ↓
   Data Layer (Models + DataSources + Repository Implementations)
```

### Directory Structure

```text
lib/
├── core/
│   ├── constants/       # App Constants (0.90 threshold, keys) & Arabic Strings
│   ├── error/           # Failure and Exception abstractions
│   ├── router/          # GoRouter route declarations (/courses, /course/:id, etc.)
│   ├── theme/           # Material 3 Theme & Health-Sciences Color Palette
│   └── utils/           # Pure progress calculation & unlock logic utilities
├── data/
│   ├── datasources/     # CoursesLocalDataSource (JSON asset) & ProgressLocalDataSource (SharedPreferences)
│   ├── models/          # CourseModel, SectionModel, LessonModel, LessonProgressModel (JSON serialization)
│   └── repositories/    # CourseRepositoryImpl & ProgressRepositoryImpl
├── domain/
│   ├── entities/        # Immutable domain objects (Course, Section, Lesson, LessonProgress)
│   ├── repositories/    # CourseRepository & ProgressRepository abstract interfaces
│   └── usecases/        # GetCourses, GetCourseDetails, SaveLessonProgress, IsLessonUnlocked, etc.
├── presentation/
│   ├── courses/         # CoursesCubit + CoursesPage + CourseCard + ContinueWatchingCard
│   ├── course_details/  # CourseDetailsCubit + CourseDetailsPage + SectionWidget + LessonTile
│   └── lesson_player/   # LessonPlayerCubit + LessonPlayerPage + VideoPlayerView + VideoControls
└── main.dart            # Composition root & MaterialApp RTL setup
```

### Why Lightweight Clean Architecture?
Clean Architecture ensures high testability, separation of concerns, and clear dependency flow (Presentation → Domain → Data). Abstractions were kept focused without unnecessary boilerplate (like GetIt or code-generator dependency bloat) to respect the 4–6 hour scope.

---

## State Management

* **`flutter_bloc` (Cubit)** was selected for predictable state flow and lightweight boilerplate.
* Business logic and persistence decisions are completely decoupled from UI widgets inside Cubits and Domain Use Cases.
* Separate Cubits manage specific domain boundaries:
  * `CoursesCubit`: Manages course listing, overall progress aggregates, and active "Continue Watching" candidate detection.
  * `CourseDetailsCubit`: Manages course details, sequential unlocking across flattened lesson lists, and section grouping.
  * `LessonPlayerCubit`: Manages video player state lifecycle, position debounce persistence, 90% auto-completion, speed selection, and orientation controls.

---

## Persistence Layer

* **`SharedPreferences`** was chosen over Hive/SQLite because stored progress data is small, key-value structured, and fast.
* Complete isolation behind `ProgressLocalDataSource` ensures the UI never directly accesses storage APIs.

---

## Video Playback

* Uses official `video_player` package for local asset MP4 playback.
* Playback speeds: `1.0x`, `1.25x`, `1.5x`, `2.0x`.
* Seamless orientation management: automatically locks to landscape on fullscreen toggle and cleanly restores portrait mode on pop/exit (`SystemChrome.setPreferredOrientations`).

---

## Running the Application

Ensure Flutter SDK is installed and configured on your system:

```bash
# 1. Fetch pub dependencies
flutter pub get

# 2. Run application
flutter run
```

---

## Running Unit Tests

Unit tests verify pure domain business logic (completion thresholds, sequential unlock calculation across sections, and course progress formulas):

```bash
flutter test
```

### Included Tests
1. **Completion Threshold Test**: Verifies 89% is incomplete, 90% & 95% are completed, and 0-second duration is handled safely.
2. **Sequential Unlock Test**: Verifies Lesson 0 is unlocked, subsequent lessons unlock when previous lesson is completed, and locked state blocks playback.
3. **Course Progress Test**: Verifies 2/4 completed lessons yield 50% progress and empty lists return 0% without NaN or division by zero.

---

## Acceptance Criteria Checklist

- [x] **Courses**: 2 Arabic offline courses load from JSON; dynamic progress percentages; Continue Watching card.
- [x] **Course Details**: Section collapse/expansion; duration formatting; lesson status badges; sequential unlocking across sections; friendly locked lesson dialog.
- [x] **Player**: Local MP4 playback; play/pause; seek slider; current & total duration; playback speeds (1x, 1.25x, 1.5x, 2x); orientation-aware fullscreen; 90% auto completion; next lesson navigation.
- [x] **Persistence**: Position and completion survive app restarts via `SharedPreferences`.
- [x] **RTL UX**: Native Arabic TextDirection.rtl layout with harmonious typography and alignment.
- [x] **Quality & Errors**: Zero `flutter analyze` issues; all `flutter test` unit tests pass; graceful error screens with zero uncaught red Flutter errors.

---

## Trade-offs & Scope Boundary

* **Asset Video Bundling**: Used small royalty-free video clips bundled in `assets/videos/` to keep app binary size light while maintaining 100% offline capability.
* **Dependency Injection**: Used constructor injection and manual composition root in `main.dart` instead of GetIt service locators.

---

## Known Issues

* On desktop embedders (Windows desktop build), fullscreen orientation changes rely on window size rather than physical device orientation sensors, but behaves standardly on mobile devices.

---

## With More Time

* Widget & Integration tests (Golden UI tests for Arabic RTL).
* Subtitle / Transcript support (.vtt / .srt).
* Bookmarking and personal lesson notes.
* Dark mode toggle.
* Storage migration and backup/restore options.

---

## Estimated Implementation Time

* **Total Time**: ~4.5 Hours
