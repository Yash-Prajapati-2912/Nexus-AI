import '../../domain/entities/financial_report.dart';

class CategoryBreakdownItemModel extends CategoryBreakdownItem {
  const CategoryBreakdownItemModel({
    required super.categoryName,
    required super.amount,
    required super.percentage,
    required super.colorHex,
  });

  factory CategoryBreakdownItemModel.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdownItemModel(
      categoryName: json['categoryName'] as String? ?? json['category'] as String? ?? 'General',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      colorHex: json['colorHex'] as String? ?? json['color'] as String? ?? '#6366F1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'amount': amount,
      'percentage': percentage,
      'colorHex': colorHex,
    };
  }
}

class FinancialReportModel extends FinancialReport {
  const FinancialReportModel({
    required super.timeframe,
    required super.totalIncome,
    required super.totalExpense,
    required super.netSavings,
    required super.savingsRatePercentage,
    required super.expenseBreakdown,
    required super.incomeBreakdown,
    required super.cashFlowSeries,
  });

  factory FinancialReportModel.fromJson(Map<String, dynamic> json) {
    final rawExp = json['expenseBreakdown'] as List<dynamic>? ?? [];
    final expBreakdown = rawExp
        .map((e) => CategoryBreakdownItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final rawInc = json['incomeBreakdown'] as List<dynamic>? ?? [];
    final incBreakdown = rawInc
        .map((e) => CategoryBreakdownItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final rawCashFlow = json['cashFlowSeries'] as List<dynamic>? ?? [1200.0, 800.0, 1500.0, 950.0];
    final cashFlowSeries = rawCashFlow.map((e) => (e as num).toDouble()).toList();

    return FinancialReportModel(
      timeframe: json['timeframe'] as String? ?? 'MONTHLY',
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (json['totalExpense'] as num?)?.toDouble() ?? 0.0,
      netSavings: (json['netSavings'] as num?)?.toDouble() ?? 0.0,
      savingsRatePercentage: (json['savingsRatePercentage'] as num?)?.toDouble() ?? 0.0,
      expenseBreakdown: expBreakdown,
      incomeBreakdown: incBreakdown,
      cashFlowSeries: cashFlowSeries,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timeframe': timeframe,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'netSavings': netSavings,
      'savingsRatePercentage': savingsRatePercentage,
      'expenseBreakdown': expenseBreakdown
          .map((e) => CategoryBreakdownItemModel(
                categoryName: e.categoryName,
                amount: e.amount,
                percentage: e.percentage,
                colorHex: e.colorHex,
              ).toJson())
          .toList(),
      'incomeBreakdown': incomeBreakdown
          .map((e) => CategoryBreakdownItemModel(
                categoryName: e.categoryName,
                amount: e.amount,
                percentage: e.percentage,
                colorHex: e.colorHex,
              ).toJson())
          .toList(),
      'cashFlowSeries': cashFlowSeries,
    };
  }
}
