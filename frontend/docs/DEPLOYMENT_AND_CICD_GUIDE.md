# Nexus AI — Deployment & CI/CD Guide

## 🚀 CI/CD Pipeline

The GitHub Actions workflow `.github/workflows/ci_cd.yml` automates:
1. Static code analysis (`flutter analyze`).
2. Code formatting verification (`dart format`).
3. Unit and BLoC test execution (`flutter test`).
4. Code coverage upload to Codecov.
5. Android App Bundle (`app-release.aab`) compilation.
6. iOS IPA (`nexus_ai.ipa`) compilation.

## 📱 Fastlane Deployment Lanes

### Android (`android/fastlane/Fastfile`)
- `fastlane android test`: Executes Flutter unit tests.
- `fastlane android beta`: Builds staging AAB and uploads to Google Play Internal Testing.
- `fastlane android deploy`: Builds production AAB and uploads to Google Play Production track.

### iOS (`ios/fastlane/Fastfile`)
- `fastlane ios test`: Executes Flutter unit tests.
- `fastlane ios beta`: Builds staging IPA and uploads to Apple TestFlight.
- `fastlane ios deploy`: Builds production IPA and submits to Apple App Store.
