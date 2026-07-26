import '../../domain/entities/finance_summary_entity.dart';

class FinanceSummaryModel {
  final double monthlyBudget;
  final double spentThisMonth;
  final double remainingBudget;
  final double todayExpenses;
  final double savingsGoalProgress;
  final String? aiFinancialTip;

  const FinanceSummaryModel({
    required this.monthlyBudget,
    required this.spentThisMonth,
    required this.remainingBudget,
    required this.todayExpenses,
    required this.savingsGoalProgress,
    this.aiFinancialTip,
  });

  factory FinanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return FinanceSummaryModel(
      monthlyBudget: (json['monthlyBudget'] as num?)?.toDouble() ?? 0.0,
      spentThisMonth: (json['spentThisMonth'] as num?)?.toDouble() ?? 0.0,
      remainingBudget: (json['remainingBudget'] as num?)?.toDouble() ?? 0.0,
      todayExpenses: (json['todayExpenses'] as num?)?.toDouble() ?? 0.0,
      savingsGoalProgress: (json['savingsGoalProgress'] as num?)?.toDouble() ?? 0.0,
      aiFinancialTip: json['aiFinancialTip'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'monthlyBudget': monthlyBudget,
        'spentThisMonth': spentThisMonth,
        'remainingBudget': remainingBudget,
        'todayExpenses': todayExpenses,
        'savingsGoalProgress': savingsGoalProgress,
        'aiFinancialTip': aiFinancialTip,
      };

  FinanceSummaryEntity toDomain() {
    return FinanceSummaryEntity(
      monthlyBudget: monthlyBudget,
      spentThisMonth: spentThisMonth,
      remainingBudget: remainingBudget,
      todayExpenses: todayExpenses,
      savingsGoalProgress: savingsGoalProgress,
      aiFinancialTip: aiFinancialTip,
    );
  }
}
