import '../../domain/entities/finance_summary_entity.dart';

class FinanceTransactionModel {
  final String id;
  final String title;
  final double amount;
  final String categoryName;
  final String categoryColour;
  final DateTime date;
  final bool isExpense;

  const FinanceTransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryName,
    required this.categoryColour,
    required this.date,
    required this.isExpense,
  });

  factory FinanceTransactionModel.fromJson(Map<String, dynamic> json) {
    return FinanceTransactionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Expense',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      categoryName: json['categoryName'] as String? ?? 'General',
      categoryColour: json['categoryColour'] as String? ?? '#6366F1',
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      isExpense: json['isExpense'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'categoryName': categoryName,
        'categoryColour': categoryColour,
        'date': date.toIso8601String(),
        'isExpense': isExpense,
      };

  FinanceTransactionEntity toDomain() => FinanceTransactionEntity(
        id: id,
        title: title,
        amount: amount,
        categoryName: categoryName,
        categoryColour: categoryColour,
        date: date,
        isExpense: isExpense,
      );
}

class FinanceSummaryModel {
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
  final List<FinanceTransactionModel> recentTransactions;
  final String? aiFinancialTip;

  const FinanceSummaryModel({
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

  static double _parseDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  factory FinanceSummaryModel.fromJson(Map<String, dynamic> json) {
    final spent = _parseDouble(json['spentThisMonth'] ?? json['totalSpentMonth'] ?? json['spent'] ?? json['totalExpenses']);
    final income = _parseDouble(json['totalIncome'] ?? json['monthlyIncome'] ?? json['income']);
    final net = json['netBalance'] != null || json['netCashFlow'] != null
        ? _parseDouble(json['netBalance'] ?? json['netCashFlow'])
        : (income - spent);

    final rawTx = json['recentTransactions'] as List<dynamic>? ?? [];
    final transactions = rawTx
        .map((t) => FinanceTransactionModel.fromJson(t as Map<String, dynamic>))
        .toList();

    return FinanceSummaryModel(
      monthlyBudget: _parseDouble(json['monthlyBudget'] ?? json['monthlyBudgetPlanned'] ?? json['budget']),
      spentThisMonth: spent,
      remainingBudget: _parseDouble(json['remainingBudget'] ?? json['remaining']),
      todayExpenses: _parseDouble(json['todayExpenses'] ?? json['todaysSpending'] ?? json['todaySpent']),
      savingsGoalProgress: _parseDouble(json['savingsGoalProgress'] ?? json['savingsProgressPercentage']),
      totalIncome: income,
      netBalance: net,
      activeGoalTitle: json['activeGoalTitle'] as String?,
      activeGoalTarget: _parseDouble(json['activeGoalTarget']),
      activeGoalCurrent: _parseDouble(json['activeGoalCurrent']),
      recentTransactions: transactions,
      aiFinancialTip: json['aiFinancialTip'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'monthlyBudget': monthlyBudget,
        'spentThisMonth': spentThisMonth,
        'remainingBudget': remainingBudget,
        'todayExpenses': todayExpenses,
        'savingsGoalProgress': savingsGoalProgress,
        'totalIncome': totalIncome,
        'netBalance': netBalance,
        'activeGoalTitle': activeGoalTitle,
        'activeGoalTarget': activeGoalTarget,
        'activeGoalCurrent': activeGoalCurrent,
        'recentTransactions': recentTransactions.map((t) => t.toJson()).toList(),
        'aiFinancialTip': aiFinancialTip,
      };

  FinanceSummaryEntity toDomain() {
    return FinanceSummaryEntity(
      monthlyBudget: monthlyBudget,
      spentThisMonth: spentThisMonth,
      remainingBudget: remainingBudget,
      todayExpenses: todayExpenses,
      savingsGoalProgress: savingsGoalProgress,
      totalIncome: totalIncome,
      netBalance: netBalance,
      activeGoalTitle: activeGoalTitle,
      activeGoalTarget: activeGoalTarget,
      activeGoalCurrent: activeGoalCurrent,
      recentTransactions: recentTransactions.map((t) => t.toDomain()).toList(),
      aiFinancialTip: aiFinancialTip,
    );
  }
}
