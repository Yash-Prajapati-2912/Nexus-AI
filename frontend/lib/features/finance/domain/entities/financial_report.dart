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

class CashFlowPoint extends Equatable {
  final String date;
  final double inflow;
  final double outflow;
  final double net;

  const CashFlowPoint({
    required this.date,
    required this.inflow,
    required this.outflow,
    required this.net,
  });

  @override
  List<Object?> get props => [date, inflow, outflow, net];
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
  final List<CashFlowPoint> cashFlowPoints;

  const FinancialReport({
    required this.timeframe,
    required this.totalIncome,
    required this.totalExpense,
    required this.netSavings,
    required this.savingsRatePercentage,
    required this.expenseBreakdown,
    required this.incomeBreakdown,
    required this.cashFlowSeries,
    this.cashFlowPoints = const [],
  });

  List<double> get incomeSeries =>
      cashFlowPoints.map((p) => p.inflow).toList();

  List<double> get expenseSeries =>
      cashFlowPoints.map((p) => p.outflow).toList();

  List<String> get dateLabels =>
      cashFlowPoints.map((p) => p.date).toList();

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
        cashFlowPoints,
      ];
}
