# Nexus AI — System Architecture & Engineering Reference

This document provides an architectural overview of the **Nexus AI** student life operating system, detailing layer boundaries, state management patterns, data flows, and subsystem specifications.

---

## 1. Architectural Principles

Nexus AI adheres to **Clean Architecture** and **Feature-First Organization**:

- **Separation of Concerns**: UI components are decoupled from business logic; business logic is decoupled from data sources.
- **Unidirectional Data Flow**: User interactions trigger BLoC Events ➔ BLoC processes logic ➔ BLoC emits immutable States ➔ UI rebuilds reactively.
- **Dependency Inversion**: High-level domain logic depends on abstract repository interfaces, not concrete implementations.
- **Single Source of Truth**: Data repositories manage caching, offline synchronization, and state updates centrally.

---

## 2. Layered Architecture (Frontend)

```
┌─────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                    │
│   Pages, Stateful/Stateless Widgets, Atomic Components   │
└────────────────────────────┬────────────────────────────┘
                             │ Dispatches Events / Listens to States
                             ▼
┌─────────────────────────────────────────────────────────┐
│                   STATE MANAGEMENT                      │
│      BLoC (Business Logic Components) & Cubits          │
└────────────────────────────┬────────────────────────────┘
                             │ Calls UseCases
                             ▼
┌─────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                       │
│     Entities, Value Objects, UseCases, Repositories     │
└────────────────────────────┬────────────────────────────┘
                             │ Implements Repository Interfaces
                             ▼
┌─────────────────────────────────────────────────────────┐
│                       DATA LAYER                        │
│   Repository Impls, Remote DataSources, Local Storage    │
└────────────────────────────┬────────────────────────────┘
                             │ HTTP Requests / REST API
                             ▼
┌─────────────────────────────────────────────────────────┐
│                     BACKEND SERVICE                     │
│         NestJS Server, PostgreSQL, Gemini AI            │
└─────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

1. **Presentation Layer (`lib/features/<module>/presentation/`)**:
   - Contains Flutter UI components (`Pages`, `Widgets`, `Modals`).
   - Uses `BlocBuilder`, `BlocConsumer`, and `BlocListener` to react to state changes.
   - Enforces user input validation and double-tap protection flags.

2. **State Management (`lib/features/<module>/presentation/bloc/`)**:
   - Receives user intent via immutable `Events`.
   - Invokes domain `UseCases` asynchronously.
   - Emits clean, predictable states (`Initial`, `Loading`, `Loaded`, `Error`).

3. **Domain Layer (`lib/features/<module>/domain/`)**:
   - **Entities**: Pure Dart objects representing core domain models (`TaskEntity`, `Expense`, `Budget`, `SavingsGoal`, `ChatMessage`).
   - **UseCases**: Encapsulate specific business rules (e.g. `CreateTaskUseCase`, `GetExpensesUseCase`).
   - **Repository Contracts**: Abstract interfaces (e.g., `IFinanceRepository`, `IPlannerRepository`).

4. **Data Layer (`lib/features/<module>/data/`)**:
   - **Models / DTOs**: JSON serializable Data Transfer Objects with `fromJson` and `toJson`.
   - **DataSources**: Remote HTTP calls via `ApiClient` or local caching via `PreferencesManager`.
   - **Repository Implementations**: Implement domain contracts and return `Either<Failure, T>` using functional error handling (`fpdart`).

5. **Core Infrastructure (`lib/core/`)**:
   - **`network/`**: Base REST `ApiClient` built on Dio, translating HTTP status codes into domain exceptions.
   - **`offline/`**: `SyncManager` for background synchronization.
   - **`security/`**: `SecurityService` for clipboard clearing and platform security features.
   - **`services/`**: Logger, notification driver, and connectivity monitors.

---

## 3. Subsystem Breakdown

### 1. Document Intelligence Engine
Located at `lib/features/planner/domain/services/academic_document_classifier.dart`:
- **Text Extraction**: Uses `Syncfusion` PDF library to extract selectable text from uploaded files while handling plain text and scanned PDF edge cases.
- **Stage 1 (Classification)**: Scans keywords and structural signals to classify documents into types (`syllabus`, `assignmentCollection`, `questionBank`, `notes`, etc.) and infer course titles.
- **Stage 2 (Segmentation)**: Automatically parses multi-assignment collections (such as EEJS placement materials) into independent tasks with custom deadlines, action steps, and deliverables.

### 2. Finance Engine
- **Calculations**: Computes total expenses, monthly income, budget health, daily safe spending limits, and projected month-end totals.
- **Math Safety**: Ensures all division operations guard against `0` and progress ratios clamp between `0.0` and `1.0`.

### 3. AI Agent Infrastructure
- **Context Construction**: Formats live student planner statistics and financial health metrics into contextual prompt headers.
- **Conversation State**: Manages message histories, streaming indicator states, voice prompt toggles, and retry handling.

---

## 4. API & Network Communication Contract

All REST communication is handled by `ApiClient` (`lib/core/network/api_client.dart`):
- **Authentication Header**: Bearer JWT token attached via Dio Interceptor.
- **Problem Details (RFC 7807)**: HTTP status codes (400, 401, 403, 404, 500) map to domain failures (`ValidationFailure`, `UnauthorizedFailure`, `ServerFailure`).
- **Security**: Stack traces, API keys, and internal database IDs are stripped before surfacing messages to the UI.

---

## 5. Testing & Verification Infrastructure

- **Targeted Unit Tests**: Located in `test/features/planner/` and `test/features/finance/`.
- **Widget Testing**: Verifies component rendering, user interactions, and badge formatting.
- **Static Analysis**: Enforced by `analysis_options.yaml`, requiring zero errors or warnings (`flutter analyze lib/ test/`).
