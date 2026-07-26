import '../../domain/entities/financial_health.dart';

class FinancialHealthModel extends FinancialHealth {
  const FinancialHealthModel({
    required super.overallScore,
    required super.budgetHealthScore,
    required super.savingsScore,
    required super.expenseScore,
    required super.incomeStabilityScore,
    required super.cashFlowHealthScore,
    required super.investmentReadinessScore,
    required super.wellnessRating,
    required super.summaryReasoning,
    required super.topStrengths,
    required super.keyRisks,
  });

  factory FinancialHealthModel.fromJson(Map<String, dynamic> json) {
    final rawStrengths = json['topStrengths'] as List<dynamic>? ?? ['Disciplined expense logging', 'Consistent income'];
    final rawRisks = json['keyRisks'] as List<dynamic>? ?? ['High dining out allocation'];

    return FinancialHealthModel(
      overallScore: json['overallScore'] as int? ?? json['score'] as int? ?? 82,
      budgetHealthScore: json['budgetHealthScore'] as int? ?? 78,
      savingsScore: json['savingsScore'] as int? ?? 85,
      expenseScore: json['expenseScore'] as int? ?? 80,
      incomeStabilityScore: json['incomeStabilityScore'] as int? ?? 90,
      cashFlowHealthScore: json['cashFlowHealthScore'] as int? ?? 84,
      investmentReadinessScore: json['investmentReadinessScore'] as int? ?? 72,
      wellnessRating: json['wellnessRating'] as String? ?? 'EXCELLENT',
      summaryReasoning: json['summaryReasoning'] as String? ?? json['analysis'] as String? ?? 'Your financial health is strong with stable net savings.',
      topStrengths: rawStrengths.map((e) => e.toString()).toList(),
      keyRisks: rawRisks.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overallScore': overallScore,
      'budgetHealthScore': budgetHealthScore,
      'savingsScore': savingsScore,
      'expenseScore': expenseScore,
      'incomeStabilityScore': incomeStabilityScore,
      'cashFlowHealthScore': cashFlowHealthScore,
      'investmentReadinessScore': investmentReadinessScore,
      'wellnessRating': wellnessRating,
      'summaryReasoning': summaryReasoning,
      'topStrengths': topStrengths,
      'keyRisks': keyRisks,
    };
  }
}
