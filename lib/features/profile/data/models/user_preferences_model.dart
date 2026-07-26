import '../../domain/entities/user_preferences.dart';

class UserPreferencesModel extends UserPreferences {
  const UserPreferencesModel({
    required super.learningStyle,
    required super.preferredStudyTime,
    required super.communicationStyle,
    required super.productivityGoals,
    required super.financialGoals,
    required super.careerGoals,
    required super.aiTone,
    required super.profileVisibility,
    super.aiDataSharing,
    super.analyticsConsent,
    super.personalizedRecommendations,
  });

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      learningStyle: json['learningStyle'] as String? ?? 'VISUAL',
      preferredStudyTime: json['preferredStudyTime'] as String? ?? 'EVENING',
      communicationStyle: json['communicationStyle'] as String? ?? 'CONCISE',
      productivityGoals: json['productivityGoals'] as String? ?? 'Complete 4 study sessions daily',
      financialGoals: json['financialGoals'] as String? ?? 'Save \$150/month towards emergency fund',
      careerGoals: json['careerGoals'] as String? ?? 'Secure Full-Stack AI Software Internship',
      aiTone: json['aiTone'] as String? ?? 'ENCOURAGEMENT',
      profileVisibility: json['profileVisibility'] as String? ?? 'PUBLIC',
      aiDataSharing: json['aiDataSharing'] as bool? ?? true,
      analyticsConsent: json['analyticsConsent'] as bool? ?? true,
      personalizedRecommendations: json['personalizedRecommendations'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'learningStyle': learningStyle,
      'preferredStudyTime': preferredStudyTime,
      'communicationStyle': communicationStyle,
      'productivityGoals': productivityGoals,
      'financialGoals': financialGoals,
      'careerGoals': careerGoals,
      'aiTone': aiTone,
      'profileVisibility': profileVisibility,
      'aiDataSharing': aiDataSharing,
      'analyticsConsent': analyticsConsent,
      'personalizedRecommendations': personalizedRecommendations,
    };
  }
}
