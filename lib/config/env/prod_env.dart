import 'app_env.dart';

/// Production Environment Configuration.
class ProdEnv implements AppEnv {
  @override
  EnvironmentType get environmentType => EnvironmentType.production;

  @override
  String get apiBaseUrl => 'https://nexus-ai-backend-1vcs.onrender.com/api/v1';

  @override
  int get connectTimeoutMs => 10000;

  @override
  int get receiveTimeoutMs => 10000;

  @override
  bool get enableNetworkLogging => false;

  @override
  bool get enableMockData => false;

  @override
  String get appTitle => 'Nexus AI';
}
