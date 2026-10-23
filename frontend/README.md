# Nexus AI - Enterprise Flutter Foundation

**Version:** 1.0.0  
**Framework:** Flutter (Dart 3.x)  
**Architecture:** Clean Architecture + Feature-First  
**State Management:** BLoC / Cubit (`flutter_bloc`)  
**Dependency Injection:** GetIt + Injectable  
**Router:** GoRouter  
**HTTP Client:** Dio  

---

## 1. Project Overview

**Nexus AI** is an AI-powered Student Life Operating System. This directory (`frontend/`) contains the complete, production-ready Flutter enterprise foundation upon which all feature modules (Authentication, Dashboard, Smart Planner, AI Planner, Smart Finance, AI Advisor, AI Mentor, Profile, Notifications, Settings) are built.

This foundation enforces strict **Clean Architecture**, **SOLID principles**, unidirectional data flow via **BLoC**, **Material 3 Design System**, hardware-backed secure storage, and a robust **Dio REST API pipeline**.

---

## 2. Directory Structure Guide

```
lib/
├── main.dart                       # Entry point (bootstraps environment)
├── bootstrap.dart                  # Async app bootstrapper (BLoC observer, Zone errors)
├── app.dart                        # MaterialApp.router setup, theme, locale delegates
├── config/                         # Environment & application constants
│   ├── env/                        # DevEnv, StagingEnv, ProdEnv configurations
│   └── constants/                  # ApiConstants, StorageKeys, AppConstants
├── core/                           # System-wide infrastructure & drivers
│   ├── error/                      # Exceptions, Failures, ErrorHandler
│   ├── network/                    # DioClient, ApiClient, Interceptors, Envelopes
│   ├── storage/                    # SecureTokenStorage, PreferencesManager, SessionManager
│   ├── services/                   # LoggerService, NotificationService, ConnectivityService
│   └── usecases/                   # Base UseCase contract
├── di/                             # Dependency Injection Container (GetIt + Injectable)
├── shared/                         # Reusable cross-cutting UI & Base Repositories
│   ├── repositories/               # BaseRepository
│   └── widgets/                    # Atomic design widgets (BaseScreen, Buttons, Inputs, Dialogs)
├── theme/                          # Material 3 Design System
│   ├── design_tokens/              # Colors, Typography, Spacing, Radius, Elevation
│   ├── app_theme.dart              # Light & Dark ThemeData builders
│   ├── theme_manager.dart          # Theme switcher
│   └── theme_extensions.dart       # Custom AI theme extensions
├── router/                         # Declarative Navigation Engine
│   ├── route_names.dart            # Route string constants
│   ├── auth_guard.dart             # Redirect navigation guard
│   ├── navigation_service.dart     # Contextless navigation helper
│   └── app_router.dart             # GoRouter instance builder
├── l10n/                           # Localization framework (i18n)
│   ├── l10n.dart                   # Supported locales list
│   └── locale_manager.dart         # Locale notifier
├── utils/                          # Low-level helpers & extensions
│   ├── validators.dart             # Form validation rules
│   ├── date_utils.dart             # Date formatting helpers
│   ├── string_utils.dart           # String helpers
│   └── extensions/                 # Context, Theme, Widget, MediaQuery extensions
└── features/                       # Feature modules (Feature-First Clean Architecture)
    ├── splash/
    ├── auth/
    └── connectivity/
```

---

## 3. Architecture & Layer Responsibilities

Each feature directory inside `features/` follows strict Clean Architecture separation:

```
[ PRESENTATION LAYER ] --> [ DOMAIN LAYER ] <-- [ DATA LAYER ]
 (Widgets, Pages, BLoCs)    (Entities, UseCases) (Repositories, DTOs, DataSources)
```

1. **Presentation Layer:** Contains UI Widgets and BLoC state controllers. It depends strictly on Domain UseCases.
2. **Domain Layer:** Pure Dart code. Contains immutable Entities, abstract Repository interfaces, and UseCases. Zero external dependencies.
3. **Data Layer:** Implements Domain Repositories. Communicates with `ApiClient` (Remote DataSource) or `SharedPreferences`/`SecureStorage` (Local DataSource).

---

## 4. State Management Guide (`flutter_bloc`)

State management follows unidirectional data flow enforced by `flutter_bloc`:

* **Events:** Immutable triggers dispatched from the UI (`Bloc.add(Event)`).
* **BLoC:** Business logic component that processes events and emits new immutable states.
* **States:** Immutable classes extending `Equatable` (`Initial`, `Loading`, `Success`, `Failure`).
* **Observer:** `AppBlocObserver` logs every state transition and error globally.

---

## 5. Dependency Injection Guide (GetIt + Injectable)

All dependencies are registered centrally in `lib/di/injection_container.dart`:

```dart
// Accessing registered instances:
final apiClient = getIt<ApiClient>();
final sessionManager = getIt<SessionManager>();
```

---

## 6. Network Layer Guide (Dio REST Pipeline)

All network traffic flows through `DioClient` and `ApiClient`:

* **`AuthInterceptor`:** Automatically injects `Authorization: Bearer <accessToken>` headers.
* **`RefreshTokenInterceptor`:** Catches `401 Unauthorized` responses and executes a mutex-locked automatic refresh flow against `/auth/refresh`.
* **`RetryInterceptor`:** Retries requests with exponential backoff during transient network drops or 503 errors.
* **`LoggingInterceptor` & `PrettyDioLogger`:** Pretty-prints request/response payloads in debug builds.
* **`ApiResponseWrapper` & `PaginatedResponse`:** Standardized JSON envelopes matching backend OpenAPI contracts.

---

## 7. Getting Started & Development Workflow

### Prerequisites
- Flutter SDK `^3.32.0` (Dart `^3.8.0`)
- Android Studio / Xcode

### Setup & Run
```bash
# 1. Install dependencies
flutter pub get

# 2. Run code generator (for freezed / json_serializable / injectable)
dart run build_runner build --delete-conflicting-outputs

# 3. Analyze code cleanliness
flutter analyze

# 4. Run application in development mode
flutter run -t lib/main.dart
```
