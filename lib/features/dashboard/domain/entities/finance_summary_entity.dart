import 'package:equatable/equatable.dart';

class FinanceSummaryEntity extends Equatable {
  final double monthlyBudget;
  final double spentThisMonth;
  final double remainingBudget;
  final double todayExpenses;
  final double savingsGoalProgress;
  final String? aiFinancialTip;

  const FinanceSummaryEntity({
    required this.monthlyBudget,
    required this.spentThisMonth,
    required this.remainingBudget,
    required this.todayExpenses,
    required this.savingsGoalProgress,
    this.aiFinancialTip,
  });

  @override
  List<Object?> get props => [
        monthlyBudget,
        spentThisMonth,
        remainingBudget,
        todayExpenses,
        savingsGoalProgress,
        aiFinancialTip,
      ];
}
