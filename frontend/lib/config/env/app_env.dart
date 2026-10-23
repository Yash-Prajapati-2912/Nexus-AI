/// Environment types enum.
enum EnvironmentType {
  development,
  staging,
  production,
}

/// Abstract Application Environment Contract.
abstract class AppEnv {
  EnvironmentType get environmentType;
  String get apiBaseUrl;
  int get connectTimeoutMs;
  int get receiveTimeoutMs;
  bool get enableNetworkLogging;
  bool get enableMockData;
  String get appTitle;

  static late AppEnv _current;
  static AppEnv get current => _current;

  static void initialize(AppEnv env) {
    _current = env;
  }
}
