import '../../domain/entities/privacy_entity.dart';

class PrivacyModel extends PrivacyEntity {
  const PrivacyModel({
    required super.analyticsConsent,
    required super.crashReportingConsent,
    required super.personalisationConsent,
    required super.aiDataUsageConsent,
    required super.retainSearchHistory,
    required super.retainConversationHistory,
  });

  factory PrivacyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyModel(
      analyticsConsent: json['analyticsConsent'] as bool? ?? true,
      crashReportingConsent: json['crashReportingConsent'] as bool? ?? true,
      personalisationConsent: json['personalisationConsent'] as bool? ?? true,
      aiDataUsageConsent: json['aiDataUsageConsent'] as bool? ?? true,
      retainSearchHistory: json['retainSearchHistory'] as bool? ?? true,
      retainConversationHistory: json['retainConversationHistory'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'analyticsConsent': analyticsConsent,
      'crashReportingConsent': crashReportingConsent,
      'personalisationConsent': personalisationConsent,
      'aiDataUsageConsent': aiDataUsageConsent,
      'retainSearchHistory': retainSearchHistory,
      'retainConversationHistory': retainConversationHistory,
    };
  }

  factory PrivacyModel.fromEntity(PrivacyEntity entity) {
    return PrivacyModel(
      analyticsConsent: entity.analyticsConsent,
      crashReportingConsent: entity.crashReportingConsent,
      personalisationConsent: entity.personalisationConsent,
      aiDataUsageConsent: entity.aiDataUsageConsent,
      retainSearchHistory: entity.retainSearchHistory,
      retainConversationHistory: entity.retainConversationHistory,
    );
  }
}
