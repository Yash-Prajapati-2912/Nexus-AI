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

class CashFlowPointModel extends CashFlowPoint {
  const CashFlowPointModel({
    required super.date,
    required super.inflow,
    required super.outflow,
    required super.net,
  });

  factory CashFlowPointModel.fromJson(Map<String, dynamic> json) {
    return CashFlowPointModel(
      date: json['date'] as String? ?? '',
      inflow: (json['inflow'] as num?)?.toDouble() ?? 0.0,
      outflow: (json['outflow'] as num?)?.toDouble() ?? 0.0,
      net: (json['net'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'inflow': inflow,
      'outflow': outflow,
      'net': net,
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
    super.cashFlowPoints = const [],
  });

  factory FinancialReportModel.fromJson(Map<String, dynamic> json) {
    final summary = json['summaryData'] as Map<String, dynamic>?;

    final rawExp = json['expenseBreakdown'] as List<dynamic>? ??
        (summary?['expenseBreakdown'] as List<dynamic>?) ??
        [];
    final expBreakdown = rawExp
        .map((e) => CategoryBreakdownItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final rawInc = json['incomeBreakdown'] as List<dynamic>? ??
        (summary?['incomeBreakdown'] as List<dynamic>?) ??
        [];
    final incBreakdown = rawInc
        .map((e) => CategoryBreakdownItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final summaryCashFlow = summary?['cashFlow'] as Map<String, dynamic>?;
    final rawDailyBreakdown = summaryCashFlow?['dailyBreakdown'] as List<dynamic>? ??
        (json['cashFlowPoints'] as List<dynamic>?);

    final List<CashFlowPointModel> cashFlowPoints = (rawDailyBreakdown != null)
        ? rawDailyBreakdown
            .map((e) => CashFlowPointModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : const [];

    List<double> cashFlowSeries;
    if (json['cashFlowSeries'] != null && json['cashFlowSeries'] is List) {
      cashFlowSeries = (json['cashFlowSeries'] as List)
          .map((e) => (e as num).toDouble())
          .toList();
    } else if (cashFlowPoints.isNotEmpty) {
      cashFlowSeries = cashFlowPoints.map((e) => e.net).toList();
    } else {
      cashFlowSeries = const [];
    }

    final timeframe = json['timeframe'] as String? ?? json['reportType'] as String? ?? 'MONTHLY';
    final totalIncome = (json['totalIncome'] as num?)?.toDouble() ??
        (summaryCashFlow?['totalInflow'] as num?)?.toDouble() ??
        0.0;
    final totalExpense = (json['totalExpense'] as num?)?.toDouble() ??
        (summaryCashFlow?['totalOutflow'] as num?)?.toDouble() ??
        (summary?['spending']?['totalExpenses'] as num?)?.toDouble() ??
        0.0;
    final netSavings = (json['netSavings'] as num?)?.toDouble() ??
        (summaryCashFlow?['netCashFlow'] as num?)?.toDouble() ??
        (totalIncome - totalExpense);
    final savingsRatePercentage = (json['savingsRatePercentage'] as num?)?.toDouble() ??
        (totalIncome > 0 ? ((netSavings / totalIncome) * 100.0).clamp(0.0, 100.0) : 0.0);

    return FinancialReportModel(
      timeframe: timeframe,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netSavings: netSavings,
      savingsRatePercentage: savingsRatePercentage,
      expenseBreakdown: expBreakdown,
      incomeBreakdown: incBreakdown,
      cashFlowSeries: cashFlowSeries,
      cashFlowPoints: cashFlowPoints,
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
      'cashFlowPoints': cashFlowPoints
          .map((p) => {
                'date': p.date,
                'inflow': p.inflow,
                'outflow': p.outflow,
                'net': p.net,
              })
          .toList(),
    };
  }
}
