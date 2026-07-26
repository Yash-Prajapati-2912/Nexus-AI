# Enterprise Files, Media & Document Management Module (Nexus-AI Mobile)

The **Enterprise Files, Media & Document Management** module provides an enterprise-wide reusable file storage platform, media gallery, multi-format document viewers (Images, PDF, Markdown, Video, Audio), background upload/download queues, storage analytics, and cross-module attachment pickers for Smart Planner, Smart Finance, AI Mentor, and Profile modules.

## 🏗️ Directory Layout & Clean Architecture

```
lib/features/files/
├── data/
│   ├── datasources/
│   │   └── file_remote_data_source.dart
│   ├── models/
│   │   ├── download_task_model.dart
│   │   ├── file_model.dart
│   │   ├── folder_model.dart
│   │   ├── storage_usage_model.dart
│   │   └── upload_task_model.dart
│   └── repositories/
│       └── file_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── download_task.dart
│   │   ├── file_item.dart
│   │   ├── folder_item.dart
│   │   ├── storage_usage.dart
│   │   └── upload_task.dart
│   ├── repositories/
│   │   └── i_file_repository.dart
│   └── usecases/
│       ├── delete_file_usecase.dart
│       ├── download_file_usecase.dart
│       ├── get_files_usecase.dart
│       ├── rename_file_usecase.dart
│       ├── search_files_usecase.dart
│       ├── share_file_usecase.dart
│       └── upload_file_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── download_bloc.dart
    │   ├── file_bloc.dart
    │   ├── file_search_bloc.dart
    │   ├── media_bloc.dart
    │   ├── storage_bloc.dart
    │   └── upload_bloc.dart
    ├── pages/
    │   ├── audio_player_page.dart
    │   ├── document_viewer_page.dart
    │   ├── downloads_page.dart
    │   ├── favourite_files_page.dart
    │   ├── file_details_page.dart
    │   ├── file_manager_page.dart
    │   ├── filter_files_page.dart
    │   ├── image_viewer_page.dart
    │   ├── media_gallery_page.dart
    │   ├── pdf_viewer_page.dart
    │   ├── recent_files_page.dart
    │   ├── search_files_page.dart
    │   ├── shared_files_page.dart
    │   ├── storage_usage_page.dart
    │   ├── trash_page.dart
    │   ├── upload_queue_page.dart
    │   └── video_player_page.dart
    └── widgets/
        ├── attachment_chip.dart
        ├── download_card.dart
        ├── file_badge.dart
        ├── file_card.dart
        ├── folder_card.dart
        ├── media_grid.dart
        ├── preview_card.dart
        ├── storage_card.dart
        ├── storage_indicator.dart
        └── upload_progress_card.dart
```

## 🔄 State Architecture & BLoCs

| BLoC | Responsibility | Events / States |
|---|---|---|
| `FileBloc` | File Manager browsing, folder navigation, rename & soft-delete | `LoadFilesEvent`, `RenameFileEvent`, `DeleteFileEvent`, `RestoreFileEvent` |
| `UploadBloc` | Single & batch background upload queue | `StartUploadEvent` |
| `DownloadBloc` | File download & signed URL generation | `StartDownloadEvent` |
| `StorageBloc` | Storage usage analytics & quota breakdown | `LoadStorageUsageEvent` |
| `MediaBloc` | Gallery filtering (Images, Videos, Audio) | `LoadMediaGalleryEvent` |
| `FileSearchBloc` | Search & filter files across modules | `SearchQueryEvent` |

## 📡 Backend API Endpoints Alignment

| Feature | Endpoint | Method | Component |
|---|---|---|---|
| Single File Upload | `/media/upload` | POST | `UploadFileUseCase` |
| Batch Files Upload | `/media/upload/multiple` | POST | `UploadBloc` |
| Get User Files | `/media` | GET | `GetFilesUseCase` / `FileBloc` |
| Media Folders | `/media/folders` | GET | `FileBloc` |
| Storage Usage Analytics | `/media/storage` | GET | `StorageBloc` |
| Update Metadata / Rename | `/media/:id` | PATCH | `RenameFileUseCase` |
| Soft Delete File | `/media/:id` | DELETE | `DeleteFileUseCase` |
| Restore Soft-Deleted File | `/media/:id/restore` | POST | `FileBloc` |
| Generate Signed URL | `/media/:id/signed-url` | GET | `DownloadFileUseCase` / `ShareFileUseCase` |
