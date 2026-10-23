# Profile & User Management Module (Nexus-AI Mobile)

The **Profile & User Management** module provides user management, academic record tracking, AI personalization, gamified achievements, statistics dashboard, connected accounts (SSO), privacy consent controls, security management, and data exports.

## 🏗️ Directory Layout & Clean Architecture

```
lib/features/profile/
├── data/
│   ├── datasources/
│   │   └── profile_remote_data_source.dart
│   ├── models/
│   │   ├── academic_profile_model.dart
│   │   ├── achievement_model.dart
│   │   ├── connected_account_model.dart
│   │   ├── security_settings_model.dart
│   │   ├── user_preferences_model.dart
│   │   ├── user_profile_model.dart
│   │   └── user_statistics_model.dart
│   └── repositories/
│       └── profile_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── academic_profile.dart
│   │   ├── achievement.dart
│   │   ├── connected_account.dart
│   │   ├── security_settings.dart
│   │   ├── user_preferences.dart
│   │   ├── user_profile.dart
│   │   └── user_statistics.dart
│   ├── repositories/
│   │   └── i_profile_repository.dart
│   └── usecases/
│       ├── change_password_usecase.dart
│       ├── delete_account_usecase.dart
│       ├── export_data_usecase.dart
│       ├── get_profile_usecase.dart
│       ├── load_statistics_usecase.dart
│       ├── update_academic_profile_usecase.dart
│       ├── update_profile_usecase.dart
│       └── upload_avatar_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── account_bloc.dart
    │   ├── achievement_bloc.dart
    │   ├── profile_bloc.dart
    │   ├── security_bloc.dart
    │   └── statistics_bloc.dart
    ├── pages/
    │   ├── academic_profile_page.dart
    │   ├── achievements_page.dart
    │   ├── connected_accounts_page.dart
    │   ├── delete_account_page.dart
    │   ├── edit_profile_page.dart
    │   ├── export_my_data_page.dart
    │   ├── goals_overview_page.dart
    │   ├── interests_page.dart
    │   ├── personal_information_page.dart
    │   ├── privacy_settings_page.dart
    │   ├── profile_completion_page.dart
    │   ├── profile_home_page.dart
    │   ├── security_overview_page.dart
    │   ├── skills_page.dart
    │   └── statistics_dashboard_page.dart
    └── widgets/
        ├── achievement_card.dart
        ├── avatar_widget.dart
        ├── completion_indicator.dart
        ├── connected_account_tile.dart
        ├── preference_tile.dart
        ├── profile_card.dart
        ├── profile_header.dart
        ├── profile_skeleton.dart
        ├── security_card.dart
        └── statistics_card.dart
```

## 🔄 State Architecture & BLoCs

| BLoC | Responsibility | Events / States |
|---|---|---|
| `ProfileBloc` | User Profile, Academic Record & Preferences | `LoadProfileEvent`, `UpdateUserProfileEvent`, `UploadAvatarEvent`, `UpdateAcademicEvent`, `UpdatePreferencesEvent` |
| `AccountBloc` | Connected Accounts, Export Data & Account Deletion | `LoadAccountsEvent`, `LinkAccountEvent`, `UnlinkAccountEvent`, `TriggerExportDataEvent`, `TriggerDeleteAccountEvent` |
| `AchievementBloc` | Badges, Streaks & Unlocked Achievements | `LoadAchievementsEvent` |
| `StatisticsBloc` | Study Hours, Task Completion & Analytics | `LoadStatisticsEvent` |
| `SecurityBloc` | Password Change, 2FA & Active Sessions | `LoadSecuritySettingsEvent`, `ChangePasswordSubmitEvent` |

## 📡 Backend API Endpoints Alignment

| Feature | Endpoint | Method | Component |
|---|---|---|---|
| Get User Profile | `/profile/me` | GET | `GetProfileUseCase` / `ProfileBloc` |
| Update Profile | `/profile/me` | PATCH | `UpdateProfileUseCase` / `ProfileBloc` |
| Upload Avatar | `/profile/avatar` | POST | `UploadAvatarUseCase` / `ProfileBloc` |
| Academic Info | `/profile/education` | GET / POST | `UpdateAcademicProfileUseCase` |
| User Analytics | `/profile/analytics` | GET | `LoadStatisticsUseCase` / `StatisticsBloc` |
| Connected Accounts | `/profile/connected-accounts` | GET / POST / DELETE | `AccountBloc` |
| Preferences & AI Consent | `/profile/preferences` | GET / PATCH | `ProfileBloc` |
| Change Password | `/profile/change-password` | POST | `ChangePasswordUseCase` / `SecurityBloc` |
| Export Data | `/profile/export-data` | POST | `ExportDataUseCase` / `AccountBloc` |
| Delete Account | `/profile/me` | DELETE | `DeleteAccountUseCase` / `AccountBloc` |
