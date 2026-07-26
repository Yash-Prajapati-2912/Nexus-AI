import 'package:equatable/equatable.dart';

class CategoryBreakdownItem extends Equatable {
  final String categoryName;
  final double amount;
  final double percentage;
  final String colorHex;

  const CategoryBreakdownItem({
    required this.categoryName,
    required this.amount,
    required this.percentage,
    required this.colorHex,
  });

  @override
  List<Object?> get props => [categoryName, amount, percentage, colorHex];
}

/// Domain entity for Financial Reports & Analytics.
class FinancialReport extends Equatable {
  final String timeframe; // DAILY, WEEKLY, MONTHLY, YEARLY
  final double totalIncome;
  final double totalExpense;
  final double netSavings;
  final double savingsRatePercentage;
  final List<CategoryBreakdownItem> expenseBreakdown;
  final List<CategoryBreakdownItem> incomeBreakdown;
  final List<double> cashFlowSeries;

  const FinancialReport({
    required this.timeframe,
    required this.totalIncome,
    required this.totalExpense,
    required this.netSavings,
    required this.savingsRatePercentage,
    required this.expenseBreakdown,
    required this.incomeBreakdown,
    required this.cashFlowSeries,
  });

  @override
  List<Object?> get props => [
        timeframe,
        totalIncome,
        totalExpense,
        netSavings,
        savingsRatePercentage,
        expenseBreakdown,
        incomeBreakdown,
        cashFlowSeries,
      ];
}
