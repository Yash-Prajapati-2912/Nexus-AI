import '../../domain/entities/savings_recommendation.dart';

class SavingsTipModel extends SavingsTip {
  const SavingsTipModel({
    required super.title,
    required super.category,
    required super.potentialMonthlySavings,
    required super.difficultyLevel,
    required super.actionableAdvice,
  });

  factory SavingsTipModel.fromJson(Map<String, dynamic> json) {
    return SavingsTipModel(
      title: json['title'] as String? ?? 'Optimization Tip',
      category: json['category'] as String? ?? 'Dining',
      potentialMonthlySavings: (json['potentialMonthlySavings'] as num?)?.toDouble() ?? (json['potentialSavings'] as num?)?.toDouble() ?? 45.0,
      difficultyLevel: json['difficultyLevel'] as String? ?? 'EASY',
      actionableAdvice: json['actionableAdvice'] as String? ?? json['tip'] as String? ?? 'Cook at home twice a week to save on takeout.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'potentialMonthlySavings': potentialMonthlySavings,
      'difficultyLevel': difficultyLevel,
      'actionableAdvice': actionableAdvice,
    };
  }
}

class SavingsRecommendationModel extends SavingsRecommendation {
  const SavingsRecommendationModel({
    required super.totalPotentialMonthlySavings,
    required super.tips,
    required super.aiStrategySummary,
  });

  factory SavingsRecommendationModel.fromJson(Map<String, dynamic> json) {
    final rawTips = json['tips'] as List<dynamic>? ?? json['recommendations'] as List<dynamic>? ?? [];
    final tipsList = rawTips
        .map((e) => SavingsTipModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SavingsRecommendationModel(
      totalPotentialMonthlySavings: (json['totalPotentialMonthlySavings'] as num?)?.toDouble() ?? 160.00,
      tips: tipsList,
      aiStrategySummary: json['aiStrategySummary'] as String? ?? json['summary'] as String? ?? 'Cut redundant streaming subscriptions and optimize grocery purchases.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPotentialMonthlySavings': totalPotentialMonthlySavings,
      'tips': tips
          .map((e) => SavingsTipModel(
                title: e.title,
                category: e.category,
                potentialMonthlySavings: e.potentialMonthlySavings,
                difficultyLevel: e.difficultyLevel,
                actionableAdvice: e.actionableAdvice,
              ).toJson())
          .toList(),
      'aiStrategySummary': aiStrategySummary,
    };
  }
}
