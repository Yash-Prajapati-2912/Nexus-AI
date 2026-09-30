import 'package:equatable/equatable.dart';

class FinanceTransactionEntity extends Equatable {
  final String id;
  final String title;
  final double amount;
  final String categoryName;
  final String categoryColour;
  final DateTime date;
  final bool isExpense;

  const FinanceTransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryName,
    required this.categoryColour,
    required this.date,
    required this.isExpense,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        categoryName,
        categoryColour,
        date,
        isExpense,
      ];
}

class FinanceSummaryEntity extends Equatable {
  final double monthlyBudget;
  final double spentThisMonth;
  final double remainingBudget;
  final double todayExpenses;
  final double savingsGoalProgress;
  final double totalIncome;
  final double netBalance;
  final String? activeGoalTitle;
  final double activeGoalTarget;
  final double activeGoalCurrent;
  final List<FinanceTransactionEntity> recentTransactions;
  final String? aiFinancialTip;

  const FinanceSummaryEntity({
    required this.monthlyBudget,
    required this.spentThisMonth,
    required this.remainingBudget,
    required this.todayExpenses,
    required this.savingsGoalProgress,
    this.totalIncome = 0.0,
    this.netBalance = 0.0,
    this.activeGoalTitle,
    this.activeGoalTarget = 0.0,
    this.activeGoalCurrent = 0.0,
    this.recentTransactions = const [],
    this.aiFinancialTip,
  });

  @override
  List<Object?> get props => [
        monthlyBudget,
        spentThisMonth,
        remainingBudget,
        todayExpenses,
        savingsGoalProgress,
        totalIncome,
        netBalance,
        activeGoalTitle,
        activeGoalTarget,
        activeGoalCurrent,
        recentTransactions,
        aiFinancialTip,
      ];
}
