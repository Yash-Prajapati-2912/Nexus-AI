import '../../domain/entities/developer_settings_entity.dart';

class DeveloperSettingsModel extends DeveloperSettingsEntity {
  const DeveloperSettingsModel({
    required super.environment,
    required super.apiBaseUrl,
    required super.enableNetworkLogs,
    required super.enableDioLogger,
    required super.showPerformanceOverlay,
    required super.featureFlags,
  });

  factory DeveloperSettingsModel.fromJson(Map<String, dynamic> json) {
    Map<String, bool> flags = {};
    if (json['featureFlags'] != null && json['featureFlags'] is Map) {
      (json['featureFlags'] as Map).forEach((key, value) {
        if (value is bool) flags[key.toString()] = value;
      });
    }

    return DeveloperSettingsModel(
      environment: json['environment'] as String? ?? 'Development',
      apiBaseUrl: json['apiBaseUrl'] as String? ?? 'http://localhost:3000/api/v1',
      enableNetworkLogs: json['enableNetworkLogs'] as bool? ?? true,
      enableDioLogger: json['enableDioLogger'] as bool? ?? true,
      showPerformanceOverlay: json['showPerformanceOverlay'] as bool? ?? false,
      featureFlags: flags.isNotEmpty
          ? flags
          : const {
              'ai_mentor_v2': true,
              'smart_finance_insights': true,
              'biometric_passkeys': false,
              'offline_first_sync': true,
            },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'environment': environment,
      'apiBaseUrl': apiBaseUrl,
      'enableNetworkLogs': enableNetworkLogs,
      'enableDioLogger': enableDioLogger,
      'showPerformanceOverlay': showPerformanceOverlay,
      'featureFlags': featureFlags,
    };
  }

  factory DeveloperSettingsModel.fromEntity(DeveloperSettingsEntity entity) {
    return DeveloperSettingsModel(
      environment: entity.environment,
      apiBaseUrl: entity.apiBaseUrl,
      enableNetworkLogs: entity.enableNetworkLogs,
      enableDioLogger: entity.enableDioLogger,
      showPerformanceOverlay: entity.showPerformanceOverlay,
      featureFlags: entity.featureFlags,
    );
  }
}
