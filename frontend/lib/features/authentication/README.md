# Authentication Feature Module - Nexus AI

**Module:** Authentication (`lib/features/authentication/`)  
**Architecture:** Clean Architecture + Feature-First  
**State Management:** BLoC Pattern (`flutter_bloc`)  

---

## 1. Module Overview

The **Authentication Feature Module** is the primary reference implementation for user identity, credential verification, JWT token lifecycle management, password recovery, and email verification in Nexus AI.

It interacts directly with backend endpoints (`/api/v1/auth/*`), storing tokens inside OS hardware security modules via `SecureTokenStorage` and managing automatic token refresh rotation.

---

## 2. Directory Layout & Layer Responsibilities

```
lib/features/authentication/
├── domain/                                   # Domain Layer (Pure Dart)
│   ├── entities/
│   │   ├── user_entity.dart                  # User business model
│   │   └── auth_tokens_entity.dart           # Tokens business model
│   ├── repositories/
│   │   └── i_auth_repository.dart            # Domain contract
│   └── usecases/                             # 10 Single-purpose Use Cases
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       ├── logout_usecase.dart
│       ├── logout_all_usecase.dart
│       ├── forgot_password_usecase.dart
│       ├── reset_password_usecase.dart
│       ├── refresh_token_usecase.dart
│       ├── verify_email_usecase.dart
│       ├── resend_verification_usecase.dart
│       └── load_current_user_usecase.dart
├── data/                                     # Data Layer
│   ├── datasources/
│   │   └── auth_remote_data_source.dart      # REST Client calls to /auth/*
│   ├── models/
│   │   ├── user_model.dart                   # DTO & Entity Mapper
│   │   ├── auth_tokens_model.dart            # DTO & Entity Mapper
│   │   └── dtos/                             # Request JSON Payload DTOs
│   └── repositories/
│       └── auth_repository_impl.dart         # Implements IAuthRepository
└── presentation/                             # Presentation Layer (UI & BLoC)
    ├── bloc/
    │   ├── authentication_bloc.dart          # Central State Machine
    │   ├── authentication_event.dart         # 11 Dispatched Events
    │   └── authentication_state.dart         # 9 Emitted States
    ├── pages/
    │   ├── splash_page.dart                  # Silent session restore & routing
    │   ├── onboarding_page.dart              # Multi-slide introduction
    │   ├── login_page.dart                   # Credentials & Remember Me
    │   ├── register_page.dart                # Account creation & terms
    │   ├── forgot_password_page.dart         # Password reset email dispatch
    │   ├── reset_password_page.dart          # New password token submit
    │   ├── verify_email_page.dart            # Deep-link email token verification
    │   ├── email_verification_pending_page.dart # Unverified account notice
    │   └── session_expired_page.dart         # Token expiration prompt
    └── widgets/                              # Atomic Auth UI Components
        ├── auth_scaffold.dart
        ├── auth_header.dart
        ├── auth_card.dart
        ├── app_logo.dart
        ├── remember_me_checkbox.dart
        ├── terms_checkbox.dart
        ├── forgot_password_link.dart
        ├── auth_footer.dart
        └── loading_overlay.dart
```

---

## 3. BLoC State Machine & Event Specifications

### Events (`AuthenticationEvent`)
- `AppStartedEvent`: Checks session & triggers silent token refresh.
- `LoginRequestedEvent(email, password, rememberMe)`: Submits credentials.
- `RegisterRequestedEvent(email, password, fullName)`: Registers new student.
- `LogoutRequestedEvent`: Revokes token session locally and remotely.
- `LogoutAllRequestedEvent`: Revokes all active user sessions across all devices.
- `ForgotPasswordRequestedEvent(email)`: Dispatches password reset link.
- `ResetPasswordRequestedEvent(token, newPassword)`: Updates user password.
- `VerifyEmailRequestedEvent(token)`: Validates email verification link.
- `ResendVerificationRequestedEvent(email)`: Re-sends verification email.
- `LoadCurrentUserRequestedEvent`: Fetches `/auth/me` user metadata.

### States (`AuthenticationState`)
- `AuthInitialState`: Initial uninitialized state.
- `AuthLoadingState`: Form submission or API request in progress.
- `AuthenticatedState(user)`: User successfully authenticated.
- `UnauthenticatedState`: User unauthenticated.
- `EmailVerificationPendingState(email)`: User account created but email not verified.
- `PasswordResetSentState(email)`: Reset email successfully dispatched.
- `PasswordResetSuccessState`: Password updated successfully.
- `EmailVerificationSuccessState`: Email address verified successfully.
- `SessionExpiredState`: Refresh token invalid/expired; prompts re-login.
- `AuthFailureState(message)`: Operative error emitted to UI (renders SnackBar).

---

## 4. API Endpoints Mapping

| Endpoint | Method | DTO Class | Repository Implementation |
| :--- | :--- | :--- | :--- |
| `/api/v1/auth/login` | `POST` | `LoginRequestDto` | `AuthRepositoryImpl.login()` |
| `/api/v1/auth/register` | `POST` | `RegisterRequestDto` | `AuthRepositoryImpl.register()` |
| `/api/v1/auth/refresh` | `POST` | `{ refreshToken }` | `AuthRepositoryImpl.refreshToken()` |
| `/api/v1/auth/logout` | `POST` | Bearer Token | `AuthRepositoryImpl.logout()` |
| `/api/v1/auth/logout-all` | `POST` | Bearer Token | `AuthRepositoryImpl.logoutAll()` |
| `/api/v1/auth/forgot-password` | `POST` | `ForgotPasswordRequestDto` | `AuthRepositoryImpl.forgotPassword()` |
| `/api/v1/auth/reset-password` | `POST` | `ResetPasswordRequestDto` | `AuthRepositoryImpl.resetPassword()` |
| `/api/v1/auth/verify-email` | `POST` | `VerifyEmailRequestDto` | `AuthRepositoryImpl.verifyEmail()` |
| `/api/v1/auth/resend-verification` | `POST` | `{ email }` | `AuthRepositoryImpl.resendVerification()` |
| `/api/v1/auth/me` | `GET` | Bearer Token | `AuthRepositoryImpl.getCurrentUser()` |
