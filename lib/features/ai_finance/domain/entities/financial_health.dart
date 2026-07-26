import 'package:equatable/equatable.dart';

/// Domain entity representing overall Financial Health & Score.
class FinancialHealth extends Equatable {
  final int overallScore; // 0 - 100
  final int budgetHealthScore;
  final int savingsScore;
  final int expenseScore;
  final int incomeStabilityScore;
  final int cashFlowHealthScore;
  final int investmentReadinessScore;
  final String wellnessRating; // EXCELLENT, GOOD, MODERATE, NEEDS_ATTENTION
  final String summaryReasoning;
  final List<String> topStrengths;
  final List<String> keyRisks;

  const FinancialHealth({
    required this.overallScore,
    required this.budgetHealthScore,
    required this.savingsScore,
    required this.expenseScore,
    required this.incomeStabilityScore,
    required this.cashFlowHealthScore,
    required this.investmentReadinessScore,
    required this.wellnessRating,
    required this.summaryReasoning,
    required this.topStrengths,
    required this.keyRisks,
  });

  @override
  List<Object?> get props => [
        overallScore,
        budgetHealthScore,
        savingsScore,
        expenseScore,
        incomeStabilityScore,
        cashFlowHealthScore,
        investmentReadinessScore,
        wellnessRating,
        summaryReasoning,
        topStrengths,
        keyRisks,
      ];
}
