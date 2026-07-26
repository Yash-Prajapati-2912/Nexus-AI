import 'package:equatable/equatable.dart';

class DeveloperSettingsEntity extends Equatable {
  final String environment;
  final String apiBaseUrl;
  final bool enableNetworkLogs;
  final bool enableDioLogger;
  final bool showPerformanceOverlay;
  final Map<String, bool> featureFlags;

  const DeveloperSettingsEntity({
    required this.environment,
    required this.apiBaseUrl,
    required this.enableNetworkLogs,
    required this.enableDioLogger,
    required this.showPerformanceOverlay,
    required this.featureFlags,
  });

  factory DeveloperSettingsEntity.initial() {
    return const DeveloperSettingsEntity(
      environment: 'Development',
      apiBaseUrl: 'http://localhost:3000/api/v1',
      enableNetworkLogs: true,
      enableDioLogger: true,
      showPerformanceOverlay: false,
      featureFlags: {
        'ai_mentor_v2': true,
        'smart_finance_insights': true,
        'biometric_passkeys': false,
        'offline_first_sync': true,
      },
    );
  }

  DeveloperSettingsEntity copyWith({
    String? environment,
    String? apiBaseUrl,
    bool? enableNetworkLogs,
    bool? enableDioLogger,
    bool? showPerformanceOverlay,
    Map<String, bool>? featureFlags,
  }) {
    return DeveloperSettingsEntity(
      environment: environment ?? this.environment,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      enableNetworkLogs: enableNetworkLogs ?? this.enableNetworkLogs,
      enableDioLogger: enableDioLogger ?? this.enableDioLogger,
      showPerformanceOverlay: showPerformanceOverlay ?? this.showPerformanceOverlay,
      featureFlags: featureFlags ?? this.featureFlags,
    );
  }

  @override
  List<Object?> get props => [
        environment,
        apiBaseUrl,
        enableNetworkLogs,
        enableDioLogger,
        showPerformanceOverlay,
        featureFlags,
      ];
}
