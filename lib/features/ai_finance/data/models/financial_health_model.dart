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
    final rawStrengths = (json['strengths'] as List<dynamic>?) ??
        (json['topStrengths'] as List<dynamic>?) ??
        [];
    final rawRisks = (json['warnings'] as List<dynamic>?) ??
        (json['weaknesses'] as List<dynamic>?) ??
        (json['keyRisks'] as List<dynamic>?) ??
        [];

    final confScore = (json['confidenceScore'] as num?)?.toDouble();
    final defaultScore = confScore != null ? (confScore * 100).toInt() : 0;

    final overall = json['overallScore'] as int? ?? json['score'] as int? ?? defaultScore;
    final wellness = json['wellnessRating'] as String? ??
        (overall >= 80 ? 'EXCELLENT' : overall >= 60 ? 'GOOD' : overall > 0 ? 'FAIR' : 'NEUTRAL');

    return FinancialHealthModel(
      overallScore: overall,
      budgetHealthScore: json['budgetHealthScore'] as int? ?? overall,
      savingsScore: json['savingsScore'] as int? ?? overall,
      expenseScore: json['expenseScore'] as int? ?? overall,
      incomeStabilityScore: json['incomeStabilityScore'] as int? ?? overall,
      cashFlowHealthScore: json['cashFlowHealthScore'] as int? ?? overall,
      investmentReadinessScore: json['investmentReadinessScore'] as int? ?? overall,
      wellnessRating: wellness,
      summaryReasoning: json['summary'] as String? ??
          json['summaryReasoning'] as String? ??
          json['analysis'] as String? ??
          'No AI financial summary available.',
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
