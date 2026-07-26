import 'package:equatable/equatable.dart';

/// Domain entity for AI Financial Goal Analysis.
class GoalAnalysis extends Equatable {
  final String goalId;
  final String goalTitle;
  final double currentProgressPercentage;
  final String riskLevel; // LOW, MODERATE, HIGH_RISK
  final DateTime predictedCompletionDate;
  final double recommendedMonthlyContribution;
  final String aiOptimizationTip;

  const GoalAnalysis({
    required this.goalId,
    required this.goalTitle,
    required this.currentProgressPercentage,
    required this.riskLevel,
    required this.predictedCompletionDate,
    required this.recommendedMonthlyContribution,
    required this.aiOptimizationTip,
  });

  @override
  List<Object?> get props => [
        goalId,
        goalTitle,
        currentProgressPercentage,
        riskLevel,
        predictedCompletionDate,
        recommendedMonthlyContribution,
        aiOptimizationTip,
      ];
}
