import 'package:equatable/equatable.dart';

/// Domain entity representing Preferences & AI Personalisation.
class UserPreferences extends Equatable {
  final String learningStyle; // VISUAL, AUDITORY, READING, KINESTHETIC
  final String preferredStudyTime; // MORNING, AFTERNOON, EVENING, NIGHT
  final String communicationStyle; // DIRECT, DETAILED, CONCISE, ENCOURAGEMENT
  final String productivityGoals;
  final String financialGoals;
  final String careerGoals;
  final String aiTone; // ENCOURAGEMENT, FORMAL, SOCRATIC, STRICT
  final String profileVisibility; // PUBLIC, PRIVATE, FRIENDS_ONLY
  final bool aiDataSharing;
  final bool analyticsConsent;
  final bool personalizedRecommendations;

  const UserPreferences({
    required this.learningStyle,
    required this.preferredStudyTime,
    required this.communicationStyle,
    required this.productivityGoals,
    required this.financialGoals,
    required this.careerGoals,
    required this.aiTone,
    required this.profileVisibility,
    this.aiDataSharing = true,
    this.analyticsConsent = true,
    this.personalizedRecommendations = true,
  });

  @override
  List<Object?> get props => [
        learningStyle,
        preferredStudyTime,
        communicationStyle,
        productivityGoals,
        financialGoals,
        careerGoals,
        aiTone,
        profileVisibility,
        aiDataSharing,
        analyticsConsent,
        personalizedRecommendations,
      ];
}
