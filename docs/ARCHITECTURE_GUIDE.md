# Nexus AI — Enterprise Mobile Architecture Guide

## 🏛 System Architecture Overview

Nexus AI is built using **Clean Architecture** principles separated into discrete, decoupled layers:

```
+-------------------------------------------------------------+
|                     PRESENTATION LAYER                      |
| (Pages, Widgets, BLoCs, Material 3 Design System, GoRouter) |
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
|                        DOMAIN LAYER                         |
|   (Entities, Use Cases, Value Objects, Repository Interfaces)|
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
|                         DATA LAYER                          |
|   (Models/DTOs, Repository Impls, Remote & Local DataSources)|
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
|                    INFRASTRUCTURE LAYER                     |
|  (Dio HTTP, SharedPreferences, FlutterSecureStorage, Sync)  |
+-------------------------------------------------------------+
```

## 🧱 Key Design Principles

1. **SOLID Principles**: Single responsibility per use case, dependency inversion via interfaces (`ISettingsRepository`, `IAuthRepository`).
2. **DRY & Reusability**: Common components (`PreferenceCard`, `SwitchTile`, `SettingsTile`, `SyncStatusIndicator`) shared across features.
3. **Immutability**: All states extend `Equatable` to minimize unnecessary widget rebuilds.
4. **Dependency Injection**: Registered in `injection_container.dart` via `GetIt` and `@InjectableInit()`.
