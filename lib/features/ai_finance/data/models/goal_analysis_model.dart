import '../../domain/entities/goal_analysis.dart';

class GoalAnalysisModel extends GoalAnalysis {
  const GoalAnalysisModel({
    required super.goalId,
    required super.goalTitle,
    required super.currentProgressPercentage,
    required super.riskLevel,
    required super.predictedCompletionDate,
    required super.recommendedMonthlyContribution,
    required super.aiOptimizationTip,
  });

  factory GoalAnalysisModel.fromJson(Map<String, dynamic> json) {
    return GoalAnalysisModel(
      goalId: json['goalId'] as String? ?? json['id'] as String? ?? 'g1',
      goalTitle: json['goalTitle'] as String? ?? json['title'] as String? ?? 'Savings Goal',
      currentProgressPercentage: (json['currentProgressPercentage'] as num?)?.toDouble() ?? 45.0,
      riskLevel: json['riskLevel'] as String? ?? 'LOW',
      predictedCompletionDate: json['predictedCompletionDate'] != null ? DateTime.parse(json['predictedCompletionDate'] as String) : DateTime.now().add(const Duration(days: 90)),
      recommendedMonthlyContribution: (json['recommendedMonthlyContribution'] as num?)?.toDouble() ?? 120.0,
      aiOptimizationTip: json['aiOptimizationTip'] as String? ?? 'On track! Increase monthly contribution by ₹200 to finish 2 weeks early.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goalId': goalId,
      'goalTitle': goalTitle,
      'currentProgressPercentage': currentProgressPercentage,
      'riskLevel': riskLevel,
      'predictedCompletionDate': predictedCompletionDate.toIso8601String(),
      'recommendedMonthlyContribution': recommendedMonthlyContribution,
      'aiOptimizationTip': aiOptimizationTip,
    };
  }
}
