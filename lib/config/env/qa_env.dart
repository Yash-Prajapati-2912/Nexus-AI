import 'app_env.dart';

class QAEnv extends AppEnv {
  @override
  EnvironmentType get environmentType => EnvironmentType.staging;

  @override
  String get apiBaseUrl => 'https://qa-api.nexusai.com/api/v1';

  @override
  int get connectTimeoutMs => 15000;

  @override
  int get receiveTimeoutMs => 15000;

  @override
  bool get enableNetworkLogging => true;

  @override
  bool get enableMockData => false;

  @override
  String get appTitle => 'Nexus AI (QA)';
}
