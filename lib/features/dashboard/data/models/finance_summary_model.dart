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

  static double _parseDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  factory FinanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return FinanceSummaryModel(
      monthlyBudget: _parseDouble(json['monthlyBudget'] ?? json['monthlyBudgetPlanned'] ?? json['budget']),
      spentThisMonth: _parseDouble(json['spentThisMonth'] ?? json['totalSpentMonth'] ?? json['spent'] ?? json['totalExpenses']),
      remainingBudget: _parseDouble(json['remainingBudget'] ?? json['remaining']),
      todayExpenses: _parseDouble(json['todayExpenses'] ?? json['todaysSpending'] ?? json['todaySpent']),
      savingsGoalProgress: _parseDouble(json['savingsGoalProgress'] ?? json['savingsProgressPercentage']),
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
