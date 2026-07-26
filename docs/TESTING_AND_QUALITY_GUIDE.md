# Nexus AI — Testing & Quality Strategy

## 🧪 Testing Pyramid

1. **Unit Tests (`test/features/*/`)**: Test Use Cases, Repositories, DataSources, Models.
2. **BLoC Tests (`test/features/*/bloc/`)**: Test state transitions given specific events using `bloc_test`.
3. **Widget & Golden Tests**: Test reusable UI widgets, responsiveness, and Material 3 rendering.
4. **Integration Tests**: End-to-end user flows.

## 🛠 Running Test Commands

```bash
# Run all unit and bloc tests
flutter test

# Run tests with code coverage report
flutter test --coverage

# Format code according to Flutter style guide
dart format --set-exit-if-changed .

# Perform static analysis
flutter analyze
```
