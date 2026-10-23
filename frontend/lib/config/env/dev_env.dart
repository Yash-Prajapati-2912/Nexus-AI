import 'package:flutter/foundation.dart';
import 'app_env.dart';

/// Development Environment Configuration.
class DevEnv implements AppEnv {
  @override
  EnvironmentType get environmentType => EnvironmentType.development;

  @override
  String get apiBaseUrl => kIsWeb ? 'http://localhost:3000/api/v1' : 'http://127.0.0.1:3000/api/v1';

  @override
  int get connectTimeoutMs => 15000;

  @override
  int get receiveTimeoutMs => 15000;

  @override
  bool get enableNetworkLogging => true;

  @override
  bool get enableMockData => false;

  @override
  String get appTitle => 'Nexus AI (DEV)';
}
