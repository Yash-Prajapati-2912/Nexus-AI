# Smart Planner Feature Module - Nexus AI

**Module:** Smart Planner (`lib/features/planner/`)  
**Architecture:** Clean Architecture + BLoC  

---

## 1. Overview

The **Smart Planner Module** provides full task management, assignment tracking, study sessions, goals, milestones, and calendar schedule planning for students.

---

## 2. Directory Layout

```
lib/features/planner/
├── domain/                                   # Domain Layer
│   ├── entities/
│   │   ├── task_entity.dart
│   │   ├── assignment_entity.dart
│   │   ├── study_session_entity.dart
│   │   ├── goal_entity.dart
│   │   ├── milestone_entity.dart
│   │   ├── calendar_event_entity.dart
│   │   └── planner_filter_entity.dart
│   ├── repositories/
│   │   └── i_planner_repository.dart
│   └── usecases/                             # 11 Single-Purpose Use Cases
│       ├── get_planner_usecase.dart
│       ├── create_task_usecase.dart
│       ├── update_task_usecase.dart
│       ├── delete_task_usecase.dart
│       ├── complete_task_usecase.dart
│       ├── create_assignment_usecase.dart
│       ├── update_assignment_usecase.dart
│       ├── delete_assignment_usecase.dart
│       ├── create_study_session_usecase.dart
│       ├── get_calendar_events_usecase.dart
│       └── search_planner_usecase.dart
├── data/                                     # Data Layer
│   ├── datasources/
│   │   └── planner_remote_data_source.dart
│   ├── models/
│   │   ├── task_model.dart
│   │   ├── assignment_model.dart
│   │   ├── study_session_model.dart
│   │   ├── goal_model.dart
│   │   ├── milestone_model.dart
│   │   └── calendar_event_model.dart
│   └── repositories/
│       └── planner_repository_impl.dart
└── presentation/                             # Presentation Layer
    ├── bloc/
    │   ├── planner_bloc.dart
    │   ├── planner_event.dart
    │   └── planner_state.dart
    ├── pages/
    │   ├── planner_home_page.dart
    │   └── create_task_page.dart
    └── widgets/
        ├── task_card.dart
        ├── assignment_card.dart
        ├── study_session_card.dart
        ├── goal_card.dart
        ├── milestone_card.dart
        ├── calendar_tile.dart
        ├── priority_badge.dart
        └── status_badge.dart
```
