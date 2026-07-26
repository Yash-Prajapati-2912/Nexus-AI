# Enterprise Backend API Freeze & Flutter Integration Contract
**Target Version**: `v1.0.0-FREEZE`  
**Document Status**: `APPROVED & IMMUTABLE`  
**Classification**: `Technical Specification / Source of Truth`  
**Effective Date**: July 25, 2026  

---

## 1. Project Overview

### 1.1 Purpose
This document serves as the **single source of truth** and formal **API Freeze Contract** between the Nexus AI Backend engineering team and the Flutter Mobile/Web frontend engineering team. It specifies all HTTP endpoints, DTO contracts, authentication mechanisms, error codes, AI response schemas, offline synchronization rules, and client-side integration guidelines for the **Nexus AI Student Life Operating System**.

### 1.2 System Architecture
- **Backend Stack**: NestJS 10, TypeScript 5, PostgreSQL 16 (TypeORM), Redis 7, BullMQ, OpenTelemetry, NGINX, Docker.
- **Frontend Architecture**: Flutter (Dart), Clean Architecture (Presentation, Domain, Data layers), BLoC / Riverpod State Management, Dio HTTP Client, Isar / Hive Local Persistence.
- **Communication Flow**: HTTPS REST APIs (JSON over TLS), WebSocket / SSE for realtime events, Multipart form-data for media uploads.
- **API Philosophy**: Strict RESTful conventions, unified JSON envelope formatting, RFC 7807 problem details error handling, deterministic caching, client correlation IDs.
- **API Versioning**: Prefix path versioning (`/v1/`).

---

## 2. API Freeze Policy

### 2.1 Freeze Scope
Effective immediately, the following contract elements are **FROZEN**:
1. All HTTP endpoint URLs, query parameters, path variables, and HTTP verbs.
2. All Request and Response DTO field names, data types, nullability, and enum options.
3. Universal API response envelope structures (`success`, `data`, `meta`, `error`, `requestId`).
4. Error payload schemas and error codes.
5. Header specifications (`Authorization`, `x-correlation-id`, `Content-Type`).

### 2.2 Breaking Changes & Deprecation Rules
- **Breaking Changes**: Strictly prohibited in `v1.x`. Any field removal, field renaming, or type mutation is considered a breaking change.
- **Additive Changes**: Non-breaking additions (e.g., optional response fields) are permitted subject to the change approval workflow.
- **Deprecation Lifecycle**: Deprecated fields will carry an `x-api-deprecated: true` response header and remain supported for at least 180 days prior to removal in `v2.0`.

### 2.3 Change Approval Workflow
Any proposed modifications to this contract must follow this approval process:
1. Submit an API Change RFC to the Principal Architect.
2. Review impact with Flutter Lead Engineer.
3. Re-issue updated contract document version (e.g., `v1.1.0-FREEZE`).

---

## 3. Authentication Contract

### 3.1 Token Strategy
- **Access Token**: Short-lived JWT (Duration: **15 minutes**). Sent via `Authorization: Bearer <token>` header.
- **Refresh Token**: Long-lived secure token (Duration: **7 days**). Exchanged at `/v1/auth/refresh`.

### 3.2 Key Auth Endpoints
- `POST /v1/auth/register`: User registration with email, password, role, and initial profile details.
- `POST /v1/auth/login`: User authentication returning `accessToken`, `refreshToken`, and user summary.
- `POST /v1/auth/refresh`: Issues a new `accessToken` using a valid `refreshToken`.
- `POST /v1/auth/logout`: Invalidates active refresh token and purges session.

### 3.3 Auth Request Headers
```http
Authorization: Bearer <accessToken>
x-correlation-id: <uuid-v4>
Content-Type: application/json
```

---

## 4. Standard API Response Contract

### 4.1 Universal Success Response Envelope
```json
{
  "success": true,
  "data": {},
  "meta": {
    "requestId": "11111111-1111-1111-1111-111111111111",
    "timestamp": "2026-07-25T23:30:00.000Z"
  }
}
```

### 4.2 Universal Paginated Response Envelope
```json
{
  "success": true,
  "data": [],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 142,
    "totalPages": 8,
    "requestId": "11111111-1111-1111-1111-111111111111",
    "timestamp": "2026-07-25T23:30:00.000Z"
  }
}
```

### 4.3 Universal Error Response Envelope (RFC 7807)
```json
{
  "success": false,
  "error": {
    "type": "https://api.nexus-ai.app/errors/INVALID_CREDENTIALS",
    "title": "Invalid Authentication Credentials",
    "status": 401,
    "detail": "The email or password provided is incorrect.",
    "instance": "/v1/auth/login",
    "code": "AUTH_401_INVALID_CREDENTIALS",
    "requestId": "11111111-1111-1111-1111-111111111111",
    "timestamp": "2026-07-25T23:30:00.000Z"
  }
}
```

---

## 5. Endpoint Catalogue

### 5.1 Authentication Module (`/v1/auth`)
- `POST /v1/auth/register`: Register new student/user account.
- `POST /v1/auth/login`: Authenticate and issue JWT pair.
- `POST /v1/auth/refresh`: Refresh access token.
- `POST /v1/auth/logout`: Revoke active session.

### 5.2 Profile Module (`/v1/profile`)
- `GET /v1/profile/me`: Get current user profile details.
- `PATCH /v1/profile/me`: Update profile information.
- `POST /v1/profile/me/avatar`: Upload avatar image.
- `GET /v1/profile/search`: Search student profiles (paginated, query filtering).

### 5.3 Smart Planner Module (`/v1/planner`)
- `GET /v1/planner/courses`: List user courses.
- `POST /v1/planner/courses`: Create new course.
- `GET /v1/planner/tasks`: List user tasks (filter by status, category, date range).
- `POST /v1/planner/tasks`: Create new task.
- `PATCH /v1/planner/tasks/:id`: Update task.
- `DELETE /v1/planner/tasks/:id`: Delete task.
- `GET /v1/planner/assignments`: List assignments (filter by upcoming/past due).

### 5.4 AI Planner Engine (`/v1/planner/ai`)
- `POST /v1/planner/ai/schedule`: Generate optimized study schedule.
- `POST /v1/planner/ai/prioritize`: AI-driven task prioritization.

### 5.5 Smart Finance Module (`/v1/finance`)
- `GET /v1/finance/accounts`: List linked accounts/wallets.
- `GET /v1/finance/transactions`: List transactions (paginated, date range, category filter).
- `POST /v1/finance/transactions`: Record new income/expense.
- `GET /v1/finance/budgets`: Get monthly budget status.
- `POST /v1/finance/budgets`: Set monthly category budgets.

### 5.6 AI Finance Engine (`/v1/finance/ai`)
- `POST /v1/finance/ai/insights`: Generate financial intelligence & savings recommendations.
- `POST /v1/finance/ai/forecast`: Predict end-of-month balance and spending velocity.

### 5.7 Context-Aware AI Mentor (`/v1/ai-mentor`)
- `POST /v1/ai-mentor/query`: Submit query to personal AI coach.
- `POST /v1/ai-mentor/roadmap`: Generate tailored academic/career roadmap.
- `GET /v1/ai-mentor/history`: Retrieve AI interaction history.

### 5.8 Dashboard Platform (`/v1/dashboard`)
- `GET /v1/dashboard/summary`: Get unified student dashboard summary.
- `GET /v1/dashboard/analytics`: Get aggregated cross-domain metrics.

### 5.9 Notification Platform (`/v1/notifications`)
- `GET /v1/notifications`: Paginated in-app notifications.
- `GET /v1/notifications/unread`: Unread notification count.
- `PATCH /v1/notifications/:id/read`: Mark single notification read.
- `PATCH /v1/notifications/read-all`: Mark all notifications read.
- `POST /v1/notifications/device`: Register FCM push device token.
- `GET /v1/notifications/preferences`: Get notification preferences.
- `PATCH /v1/notifications/preferences`: Update notification preferences.

### 5.10 Media Platform (`/v1/media`)
- `POST /v1/media/upload`: Single file upload (multipart).
- `POST /v1/media/upload/multiple`: Batch file upload (up to 10 files).
- `GET /v1/media`: Paginated media library.
- `GET /v1/media/:id`: Media file metadata.
- `DELETE /v1/media/:id`: Soft delete file.
- `GET /v1/media/:id/signed-url`: Generate temporary signed URL.

### 5.11 Settings & Admin Module (`/v1/settings`)
- `GET /v1/settings`: Master user settings.
- `PATCH /v1/settings`: Update general user settings.
- `GET /v1/settings/security`: Security settings & active sessions.
- `PATCH /v1/settings/security`: Update security settings.
- `GET /v1/settings/preferences`: Full domain preferences.
- `PATCH /v1/settings/preferences`: Update domain preferences.
- `GET /v1/settings/feature-flags`: Get active feature flags.
- `GET /v1/settings/audit-logs`: Audit logs feed.

---

## 6. DTO Catalogue

### 6.1 RegisterDto
```typescript
{
  email: string;         // Required, email format
  password: string;      // Required, min 8 chars, strong password
  fullName: string;      // Required, string
  role?: UserRole;       // Optional, default STUDENT ('STUDENT' | 'ADMIN' | 'INSTRUCTOR')
}
```

### 6.2 LoginDto
```typescript
{
  email: string;         // Required, email format
  password: string;      // Required, string
}
```

### 6.3 TaskDto
```typescript
{
  title: string;         // Required, string
  description?: string;  // Optional, string
  dueDate?: string;      // Optional, ISO 8601 timestamp
  priority: string;      // Required, ('LOW' | 'MEDIUM' | 'HIGH' | 'URGENT')
  status: string;        // Required, ('PENDING' | 'IN_PROGRESS' | 'COMPLETED')
  courseId?: string;     // Optional, UUID string
}
```

### 6.4 TransactionDto
```typescript
{
  amount: number;        // Required, positive number
  type: string;          // Required, ('INCOME' | 'EXPENSE')
  category: string;      // Required, string (e.g. 'FOOD', 'BOOKS', 'TUITION')
  description?: string;  // Optional, string
  transactionDate: string; // Required, ISO 8601 date
}
```

---

## 7. File Upload Contract

- **Endpoint**: `POST /v1/media/upload`
- **Content-Type**: `multipart/form-data`
- **Max File Sizes**:
  - Images: 10 MB
  - Documents (PDF, DOCX, PPTX): 25 MB
  - Audio / Video: 50 MB
- **Form Fields**:
  - `file`: Binary file stream
  - `folder`: Folder name (`Profile`, `Planner`, `Finance`, `Mentor`, `Dashboard`, `System`, `Temp`)
  - `visibility`: Access visibility (`PUBLIC`, `AUTHENTICATED`, `PRIVATE`)

---

## 8. AI Response Contract

All AI endpoints (`/v1/planner/ai/*`, `/v1/finance/ai/*`, `/v1/ai-mentor/*`) return a standardized JSON structure:

```json
{
  "summary": "AI summary response text",
  "reasoning": "Detailed background logic and context analysis",
  "recommendations": [
    "Prioritize Software Engineering assignment due tomorrow",
    "Allocate 2 hours for discrete mathematics study session"
  ],
  "actionItems": [
    {
      "title": "Complete Chapter 4 Homework",
      "dueDate": "2026-07-26T18:00:00Z",
      "priority": "HIGH"
    }
  ],
  "warnings": [
    "Weekly budget spending is 15% above target"
  ],
  "confidenceScore": 0.94,
  "metadata": {
    "model": "gemini-1.5-pro",
    "processingTimeMs": 340
  }
}
```

---

## 9. Pagination Contract

- **Query Parameters**:
  - `page`: Page number (1-indexed, default `1`)
  - `limit`: Items per page (default `20`, max `100`)
  - `sort`: Field to sort by (e.g. `createdAt`, `dueDate`, `amount`)
  - `order`: Sort order (`ASC` | `DESC`, default `DESC`)
  - `search`: Case-insensitive text search string

---

## 10. Error Catalogue

| Code | Status | Meaning | Frontend Handling Strategy |
|---|---|---|---|
| `AUTH_401_UNAUTHORIZED` | 401 | Missing or invalid JWT access token | Trigger token refresh interceptor. If refresh fails, redirect to `/login`. |
| `AUTH_401_INVALID_CREDENTIALS` | 401 | Incorrect email or password | Display inline validation error on login form. |
| `AUTH_403_FORBIDDEN` | 403 | User lacks required role/permission | Display "Access Denied" toast alert. |
| `PARAM_400_BAD_REQUEST` | 400 | Invalid query params or DTO validation failure | Highlight invalid input fields in UI. |
| `DATA_404_NOT_FOUND` | 404 | Resource does not exist | Show empty state view or navigate back. |
| `DATA_409_CONFLICT` | 409 | Duplicate resource (e.g. email already exists) | Display inline warning on registration form. |
| `SYS_429_TOO_MANY_REQUESTS` | 429 | Rate limit exceeded | Display "Please slow down" banner and wait for retry-after. |
| `SYS_500_INTERNAL_ERROR` | 500 | Unhandled server error | Display fallback error dialog with request ID. |

---

## 11. Flutter Integration Guide

### 11.1 Dio HTTP Client Setup & Auth Interceptor
Flutter applications must configure Dio with automatic token injection, lock-based token refresh, and correlation ID header generation:

```dart
class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorage storage;

  AuthInterceptor(this.dio, this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['x-correlation-id'] = Uuid().v4();
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Lock Dio queue & attempt token refresh
      final refreshed = await refreshToken();
      if (refreshed) {
        final retryRequest = await dio.fetch(err.requestOptions);
        return handler.resolve(retryRequest);
      }
    }
    handler.next(err);
  }
}
```

---

## 12. State Management Mapping (Flutter Clean Architecture)

| Backend Module | Flutter Feature Module | Remote Data Source | Local Data Source | BLoC / State Notifier |
|---|---|---|---|---|
| `/v1/auth` | `feature_auth` | `AuthRemoteDataSource` | `AuthLocalDataSource` (SecureStorage) | `AuthBloc` |
| `/v1/profile` | `feature_profile` | `ProfileRemoteDataSource` | `ProfileLocalDataSource` (Isar) | `ProfileBloc` |
| `/v1/planner` | `feature_planner` | `PlannerRemoteDataSource` | `PlannerLocalDataSource` (Isar) | `PlannerBloc` |
| `/v1/finance` | `feature_finance` | `FinanceRemoteDataSource` | `FinanceLocalDataSource` (Isar) | `FinanceBloc` |
| `/v1/ai-mentor` | `feature_ai_mentor` | `AIMentorRemoteDataSource` | `AIMentorLocalDataSource` (Hive) | `AIMentorBloc` |
| `/v1/dashboard` | `feature_dashboard` | `DashboardRemoteDataSource` | `DashboardLocalDataSource` | `DashboardBloc` |
| `/v1/notifications` | `feature_notifications` | `NotificationRemoteDataSource` | `NotificationLocalDataSource` | `NotificationBloc` |
| `/v1/media` | `feature_media` | `MediaRemoteDataSource` | `MediaLocalDataSource` | `MediaBloc` |
| `/v1/settings` | `feature_settings` | `SettingsRemoteDataSource` | `SettingsLocalDataSource` | `SettingsBloc` |

---

## 13. Offline Synchronisation Strategy

1. **Cache-First Read Policy**:
   - Flutter app reads cached data from Isar DB for immediate UI rendering, then triggers background network fetch to sync fresh state.
2. **Offline Action Queue**:
   - Mutations executed offline (e.g. marking task completed) are stored in an offline queue and synced in batch when connection is restored.
3. **Conflict Resolution**:
   - Server timestamp wins on concurrent updates.

---

## 14. API Performance Guidelines

- **Latency Budgets**:
  - Static & Cached Read APIs: **< 20ms**
  - Standard CRUD Operations: **< 80ms**
  - Aggregated Analytics & Search: **< 150ms**
  - AI Intelligence Query APIs: **< 600ms**
- **Payload Limits**: Default pagination limits set to 20 items.

---

## 15. Security Contract

- **JWT Validation**: Access tokens signed via RS256 / HS256 with strict expiration checks.
- **CSRF Strategy**: Unauthenticated mutating requests require CSRF tokens. Authenticated requests rely on Bearer headers.
- **Rate Limiting**: Public endpoints capped at 10 req/s. Authenticated APIs capped at 100 req/min.

---

## 16. Swagger Verification Checklist

- [x] All 11 domain modules documented in Swagger.
- [x] All endpoints include `@ApiBearerAuth()` annotations.
- [x] All DTOs documented with explicit property types and validation rules.
- [x] Request and response JSON payload examples provided.
- [x] 400, 401, 403, 404, 429, 500 error responses annotated.

---

## 17. Frontend Development Checklist

- [ ] Implement `Dio` HTTP Client with `AuthInterceptor`.
- [ ] Configure secure token storage using `flutter_secure_storage`.
- [ ] Set up local offline cache database (Isar or Hive).
- [ ] Implement global error handling dialog mapped to RFC 7807 codes.
- [ ] Build offline queue synchronization worker.
- [ ] Implement FCM push notification handler.

---

## 18. Backend Freeze Checklist

- [x] All endpoint routes and HTTP verbs verified stable.
- [x] All request and response DTO schemas frozen.
- [x] All domain enums frozen.
- [x] Standard JSON success and error envelopes locked.
- [x] Zero breaking API changes remaining.

---

## 19. Future API Versioning (`v2.0` Roadmap)

- **Version Header Support**: `/v2/` prefix introduced for major schema redesigns.
- **Deprecation Warning**: Deprecated `/v1/` endpoints will send `Warning: 299 - "Deprecated API"` response headers for 6 months prior to retirement.

---

## 20. Final Sign-off

```text
================================================================================
NEXUS AI BACKEND API FREEZE CONTRACT SIGN-OFF
RELEASE VERSION: v1.0.0-FREEZE
BACKEND STATUS: COMPLETE, VERIFIED & FROZEN
FRONTEND READY STATUS: APPROVED FOR FLUTTER IMPLEMENTATION
DATE: JULY 25, 2026
================================================================================
```
