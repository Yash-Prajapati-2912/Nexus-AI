import 'app_env.dart';

/// Staging Environment Configuration.
class StagingEnv implements AppEnv {
  @override
  EnvironmentType get environmentType => EnvironmentType.staging;

  @override
  String get apiBaseUrl => 'https://staging-api.nexusai.io/v1';

  @override
  int get connectTimeoutMs => 12000;

  @override
  int get receiveTimeoutMs => 12000;

  @override
  bool get enableNetworkLogging => true;

  @override
  bool get enableMockData => false;

  @override
  String get appTitle => 'Nexus AI (STG)';
}
