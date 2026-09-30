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
    final target = (json['targetAmount'] as num?)?.toDouble() ?? 0.0;
    final current = (json['currentAmount'] as num?)?.toDouble() ?? 0.0;
    final calculatedProgress = target > 0 ? (current / target * 100.0) : 0.0;

    return GoalAnalysisModel(
      goalId: json['goalId'] as String? ?? json['id'] as String? ?? '',
      goalTitle: json['goalTitle'] as String? ?? json['title'] as String? ?? 'Savings Goal',
      currentProgressPercentage: (json['currentProgressPercentage'] as num?)?.toDouble() ?? calculatedProgress,
      riskLevel: json['riskLevel'] as String? ?? 'LOW',
      predictedCompletionDate: json['predictedCompletionDate'] != null
          ? DateTime.tryParse(json['predictedCompletionDate'] as String) ?? DateTime.now()
          : (json['targetDate'] != null ? DateTime.tryParse(json['targetDate'] as String) ?? DateTime.now() : DateTime.now()),
      recommendedMonthlyContribution: (json['recommendedMonthlyContribution'] as num?)?.toDouble() ?? 0.0,
      aiOptimizationTip: json['aiOptimizationTip'] as String? ?? '',
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
