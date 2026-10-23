# Nexus AI — Mobile Security Architecture Guide

## 🔒 Security Hardening Matrix

| Security Layer | Implementation Details | Status |
| :--- | :--- | :--- |
| **Data At Rest Encryption** | `FlutterSecureStorage` (Keychain on iOS, Keystore + AES-256 on Android) | Enabled |
| **Data In Transit Encryption** | TLS 1.3 requirement via Dio client with SSL Certificate Pinning | Enabled |
| **Root & Jailbreak Detection** | `SecurityService.checkAppIntegrity()` checks system binaries | Enabled |
| **Screen Capture Prevention** | `FLAG_SECURE` on Android & window blur on iOS task switcher | Enabled |
| **Clipboard Auto-Purge** | Sensitive token values auto-wiped from OS clipboard after 30 seconds | Enabled |
| **JWT Token Refresh** | Automatic single-use refresh token rotation via Auth Interceptor | Enabled |
| **Logging Sanitization** | Sensitive user headers (`Authorization`, passwords) stripped from `AppLogger` | Enabled |

## 🔑 Secret Key Management

Secrets are injected per environment flavor (`DevEnv`, `QAEnv`, `StagingEnv`, `ProdEnv`) and stored at runtime in `SecretsManager`.
