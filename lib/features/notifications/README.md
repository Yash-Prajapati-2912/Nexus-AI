# Notifications & Activity Center Module (Nexus-AI Mobile)

The **Notifications & Activity Center** module provides real-time mobile push notifications (FCM), local reminder scheduling, in-app activity timeline logging, notification preferences management, and deep-linking into Smart Planner, Smart Finance, AI Mentor, and Profile modules.

## 🏗️ Directory Layout & Clean Architecture

```
lib/features/notifications/
├── data/
│   ├── datasources/
│   │   └── notification_remote_data_source.dart
│   ├── models/
│   │   ├── activity_model.dart
│   │   ├── notification_model.dart
│   │   ├── notification_preferences_model.dart
│   │   └── push_token_model.dart
│   ├── repositories/
│   │   └── notification_repository_impl.dart
│   └── services/
│       ├── fcm_push_notification_service.dart
│       └── local_notification_service.dart
├── domain/
│   ├── entities/
│   │   ├── activity_item.dart
│   │   ├── notification_item.dart
│   │   ├── notification_preferences.dart
│   │   └── push_token.dart
│   ├── repositories/
│   │   └── i_notification_repository.dart
│   └── usecases/
│       ├── delete_notification_usecase.dart
│       ├── get_activity_usecase.dart
│       ├── get_notifications_usecase.dart
│       ├── mark_notification_read_usecase.dart
│       ├── register_fcm_token_usecase.dart
│       └── update_notification_preferences_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── activity_bloc.dart
    │   ├── notification_bloc.dart
    │   ├── notification_preference_bloc.dart
    │   └── push_notification_bloc.dart
    ├── pages/
    │   ├── activity_center_page.dart
    │   ├── activity_details_page.dart
    │   ├── empty_notification_page.dart
    │   ├── error_notification_page.dart
    │   ├── notification_categories_page.dart
    │   ├── notification_center_page.dart
    │   ├── notification_details_page.dart
    │   ├── notification_filters_page.dart
    │   ├── notification_preferences_page.dart
    │   └── notification_search_page.dart
    └── widgets/
        ├── activity_card.dart
        ├── category_chip.dart
        ├── empty_notification_widget.dart
        ├── notification_card.dart
        ├── notification_header.dart
        ├── notification_preference_tile.dart
        ├── notification_skeleton.dart
        ├── priority_badge.dart
        ├── timeline_card.dart
        └── unread_badge.dart
```

## 🔄 State Architecture & BLoCs

| BLoC | Responsibility | Events / States |
|---|---|---|
| `NotificationBloc` | Notifications list, unread count & read/unread actions | `LoadNotificationsEvent`, `RefreshNotificationsEvent`, `MarkReadEvent`, `MarkAllReadEvent`, `DeleteNotificationEvent` |
| `ActivityBloc` | Activity Timeline list & action details | `LoadActivityTimelineEvent` |
| `NotificationPreferenceBloc` | Channel preferences & quiet hours | `LoadNotificationPreferencesEvent`, `UpdatePreferencesSubmitEvent` |
| `PushNotificationBloc` | FCM Token registration & push tap handling | `RegisterFCMTokenEvent`, `ReceivePushMessageEvent`, `HandleNotificationTapEvent` |

## 📡 Backend API Endpoints Alignment

| Feature | Endpoint | Method | Component |
|---|---|---|---|
| Register Device FCM Token | `/notifications/device` | POST | `RegisterFCMTokenUseCase` |
| Get Notifications | `/notifications` | GET | `GetNotificationsUseCase` / `NotificationBloc` |
| Get Unread Count | `/notifications/unread` | GET | `NotificationBloc` |
| Mark Notification Read | `/notifications/:id/read` | PATCH | `MarkNotificationReadUseCase` |
| Mark All Read | `/notifications/read-all` | PATCH | `NotificationBloc` |
| Delete Notification | `/notifications/:id` | DELETE | `DeleteNotificationUseCase` |
| Notification Preferences | `/notifications/preferences` | GET / PATCH | `NotificationPreferenceBloc` |
| Activity Timeline | `/notifications/activity` | GET | `GetActivityUseCase` / `ActivityBloc` |
