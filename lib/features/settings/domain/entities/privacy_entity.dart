import 'package:equatable/equatable.dart';

class PrivacyEntity extends Equatable {
  final bool analyticsConsent;
  final bool crashReportingConsent;
  final bool personalisationConsent;
  final bool aiDataUsageConsent;
  final bool retainSearchHistory;
  final bool retainConversationHistory;

  const PrivacyEntity({
    required this.analyticsConsent,
    required this.crashReportingConsent,
    required this.personalisationConsent,
    required this.aiDataUsageConsent,
    required this.retainSearchHistory,
    required this.retainConversationHistory,
  });

  factory PrivacyEntity.initial() {
    return const PrivacyEntity(
      analyticsConsent: true,
      crashReportingConsent: true,
      personalisationConsent: true,
      aiDataUsageConsent: true,
      retainSearchHistory: true,
      retainConversationHistory: true,
    );
  }

  PrivacyEntity copyWith({
    bool? analyticsConsent,
    bool? crashReportingConsent,
    bool? personalisationConsent,
    bool? aiDataUsageConsent,
    bool? retainSearchHistory,
    bool? retainConversationHistory,
  }) {
    return PrivacyEntity(
      analyticsConsent: analyticsConsent ?? this.analyticsConsent,
      crashReportingConsent: crashReportingConsent ?? this.crashReportingConsent,
      personalisationConsent: personalisationConsent ?? this.personalisationConsent,
      aiDataUsageConsent: aiDataUsageConsent ?? this.aiDataUsageConsent,
      retainSearchHistory: retainSearchHistory ?? this.retainSearchHistory,
      retainConversationHistory: retainConversationHistory ?? this.retainConversationHistory,
    );
  }

  @override
  List<Object?> get props => [
        analyticsConsent,
        crashReportingConsent,
        personalisationConsent,
        aiDataUsageConsent,
        retainSearchHistory,
        retainConversationHistory,
      ];
}
