import 'package:equatable/equatable.dart';

class SavingsTip extends Equatable {
  final String title;
  final String category;
  final double potentialMonthlySavings;
  final String difficultyLevel; // EASY, MODERATE, CHALLENGING
  final String actionableAdvice;

  const SavingsTip({
    required this.title,
    required this.category,
    required this.potentialMonthlySavings,
    required this.difficultyLevel,
    required this.actionableAdvice,
  });

  @override
  List<Object?> get props => [
        title,
        category,
        potentialMonthlySavings,
        difficultyLevel,
        actionableAdvice,
      ];
}

/// Domain entity for Savings Recommendations.
class SavingsRecommendation extends Equatable {
  final double totalPotentialMonthlySavings;
  final List<SavingsTip> tips;
  final String aiStrategySummary;

  const SavingsRecommendation({
    required this.totalPotentialMonthlySavings,
    required this.tips,
    required this.aiStrategySummary,
  });

  @override
  List<Object?> get props => [
        totalPotentialMonthlySavings,
        tips,
        aiStrategySummary,
      ];
}
