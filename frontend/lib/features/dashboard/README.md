# Dashboard Feature Module - Nexus AI

**Module:** Dashboard (`lib/features/dashboard/`)  
**Architecture:** Clean Architecture + BLoC  

---

## 1. Overview

The **Dashboard Feature Module** is the primary home screen of Nexus AI. It aggregates user profile metrics, today's planner tasks, monthly financial health, AI mentor recommendations, productivity streak metrics, recent notifications, and visual charts (`fl_chart`).

---

## 2. Directory Layout

```
lib/features/dashboard/
├── domain/                                   # Domain Layer
│   ├── entities/
│   │   ├── dashboard_entity.dart
│   │   ├── planner_summary_entity.dart
│   │   ├── finance_summary_entity.dart
│   │   ├── ai_insight_entity.dart
│   │   ├── notification_summary_entity.dart
│   │   ├── productivity_stats_entity.dart
│   │   └── chart_data_entity.dart
│   ├── repositories/
│   │   └── i_dashboard_repository.dart
│   └── usecases/
│       ├── get_dashboard_usecase.dart
│       ├── get_planner_summary_usecase.dart
│       ├── get_finance_summary_usecase.dart
│       ├── get_ai_insight_usecase.dart
│       └── get_notification_summary_usecase.dart
├── data/                                     # Data Layer
│   ├── datasources/
│   │   └── dashboard_remote_data_source.dart
│   ├── models/
│   │   ├── dashboard_model.dart
│   │   ├── planner_summary_model.dart
│   │   ├── finance_summary_model.dart
│   │   ├── ai_insight_model.dart
│   │   ├── notification_summary_model.dart
│   │   ├── productivity_stats_model.dart
│   │   └── chart_data_model.dart
│   └── repositories/
│       └── dashboard_repository_impl.dart
└── presentation/                             # Presentation Layer
    ├── bloc/
    │   ├── dashboard_bloc.dart
    │   ├── dashboard_event.dart
    │   └── dashboard_state.dart
    ├── pages/
    │   └── dashboard_page.dart
    └── widgets/
        ├── dashboard_header_widget.dart
        ├── quick_actions_widget.dart
        ├── today_overview_widget.dart
        ├── planner_summary_widget.dart
        ├── finance_summary_widget.dart
        ├── ai_mentor_section_widget.dart
        ├── productivity_section_widget.dart
        ├── recent_activity_widget.dart
        ├── weekly_study_chart_widget.dart
        ├── expense_chart_widget.dart
        ├── task_completion_chart_widget.dart
        └── skeleton_dashboard_widget.dart
```
