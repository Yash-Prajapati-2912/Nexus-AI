import 'package:nexus_ai/core/network/api_client.dart';
import '../models/budget_model.dart';
import '../models/expense_model.dart';
import '../models/finance_category_model.dart';
import '../models/income_model.dart';
import '../models/investment_model.dart';
import '../models/report_model.dart';
import '../models/savings_goal_model.dart';
import '../models/transaction_model.dart';
import '../../domain/entities/transaction.dart';

abstract class IFinanceRemoteDataSource {
  // Expenses
  Future<List<ExpenseModel>> getExpenses({
    String? categoryId,
    String? startDate,
    String? endDate,
    double? minAmount,
    double? maxAmount,
    String? search,
  });
  Future<ExpenseModel> createExpense(ExpenseModel expense);
  Future<ExpenseModel> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);

  // Incomes
  Future<List<IncomeModel>> getIncomes({String? sourceCategory, String? startDate, String? endDate});
  Future<IncomeModel> createIncome(IncomeModel income);
  Future<IncomeModel> updateIncome(IncomeModel income);
  Future<void> deleteIncome(String id);

  // Budgets
  Future<List<BudgetModel>> getBudgets();
  Future<BudgetModel> createBudget(BudgetModel budget);
  Future<BudgetModel> updateBudget(BudgetModel budget);

  // Savings Goals
  Future<List<SavingsGoalModel>> getSavingsGoals();
  Future<SavingsGoalModel> createSavingsGoal(SavingsGoalModel goal);
  Future<SavingsGoalModel> updateSavingsGoal(SavingsGoalModel goal);
  Future<SavingsGoalModel> addContribution(String goalId, double amount, String? note);
  Future<void> deleteSavingsGoal(String id);

  // Investments
  Future<List<InvestmentModel>> getInvestments();
  Future<InvestmentModel> createInvestment(InvestmentModel investment);
  Future<InvestmentModel> updateInvestment(InvestmentModel investment);
  Future<void> deleteInvestment(String id);

  // Categories & Transactions & Reports
  Future<List<FinanceCategoryModel>> getCategories();
  Future<FinanceCategoryModel> createCategory(FinanceCategoryModel category);
  Future<List<TransactionModel>> getTransactions({String? query, String? type});
  Future<FinancialReportModel> getFinancialReport(String timeframe);
}

class FinanceRemoteDataSourceImpl implements IFinanceRemoteDataSource {
  final ApiClient _apiClient;
  final List<InvestmentModel> _localInvestmentsCache = [];

  FinanceRemoteDataSourceImpl(this._apiClient);

  List<dynamic> _extractList(dynamic responseData) {
    dynamic payload = responseData;
    if (payload is Map<String, dynamic> && payload['data'] != null) {
      payload = payload['data'];
    }
    if (payload is Map<String, dynamic> && payload['data'] != null) {
      payload = payload['data'];
    }
    if (payload is Map<String, dynamic> && payload['items'] != null) {
      payload = payload['items'];
    }
    return (payload is List) ? payload : [];
  }

  @override
  Future<List<ExpenseModel>> getExpenses({
    String? categoryId,
    String? startDate,
    String? endDate,
    double? minAmount,
    double? maxAmount,
    String? search,
  }) async {
    final response = await _apiClient.get(
      '/finance/expenses',
      queryParameters: {
        'limit': 1000,
        if (categoryId != null) 'categoryId': categoryId,
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (minAmount != null) 'minAmount': minAmount,
        if (maxAmount != null) 'maxAmount': maxAmount,
        if (search != null) 'search': search,
      },
    );

    final list = _extractList(response.data);
    return list.map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<ExpenseModel> createExpense(ExpenseModel expense) async {
    final response = await _apiClient.post('/finance/expenses', data: expense.toCreateJson());
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return ExpenseModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<ExpenseModel> updateExpense(ExpenseModel expense) async {
    final response = await _apiClient.patch('/finance/expenses/${expense.id}', data: expense.toUpdateJson());
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return ExpenseModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _apiClient.delete('/finance/expenses/$id');
  }

  @override
  Future<List<IncomeModel>> getIncomes({String? sourceCategory, String? startDate, String? endDate}) async {
    final response = await _apiClient.get(
      '/finance/incomes',
      queryParameters: {
        'limit': 1000,
        if (sourceCategory != null && sourceCategory.isNotEmpty) 'source': sourceCategory,
        if (startDate != null && startDate.isNotEmpty) 'startDate': startDate,
        if (endDate != null && endDate.isNotEmpty) 'endDate': endDate,
      },
    );
    final list = _extractList(response.data);
    return list.map((e) => IncomeModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<IncomeModel> createIncome(IncomeModel income) async {
    final response = await _apiClient.post('/finance/incomes', data: income.toCreateJson());
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return IncomeModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<IncomeModel> updateIncome(IncomeModel income) async {
    final response = await _apiClient.patch('/finance/incomes/${income.id}', data: income.toUpdateJson());
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return IncomeModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteIncome(String id) async {
    await _apiClient.delete('/finance/incomes/$id');
  }

  @override
  Future<List<BudgetModel>> getBudgets() async {
    final response = await _apiClient.get('/finance/budgets');
    final list = _extractList(response.data);
    return list.map((e) => BudgetModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<BudgetModel> createBudget(BudgetModel budget) async {
    final response = await _apiClient.post('/finance/budgets', data: budget.toCreateJson());
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return BudgetModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<BudgetModel> updateBudget(BudgetModel budget) async {
    final response = await _apiClient.patch('/finance/budgets/${budget.id}', data: budget.toJson());
    final data = response.data as Map<String, dynamic>;
    return BudgetModel.fromJson(data);
  }

  @override
  Future<List<SavingsGoalModel>> getSavingsGoals() async {
    final response = await _apiClient.get('/finance/savings-goals');
    final list = _extractList(response.data);
    return list.map((e) => SavingsGoalModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<SavingsGoalModel> createSavingsGoal(SavingsGoalModel goal) async {
    final response = await _apiClient.post('/finance/savings-goals', data: goal.toCreateJson());
    final data = response.data as Map<String, dynamic>;
    return SavingsGoalModel.fromJson(data);
  }

  @override
  Future<SavingsGoalModel> updateSavingsGoal(SavingsGoalModel goal) async {
    final response = await _apiClient.patch('/finance/savings-goals/${goal.id}', data: goal.toUpdateJson());
    final data = response.data as Map<String, dynamic>;
    return SavingsGoalModel.fromJson(data);
  }

  @override
  Future<SavingsGoalModel> addContribution(String goalId, double amount, String? note) async {
    final response = await _apiClient.post(
      '/finance/savings-goals/$goalId/contribute',
      data: {'contributionAmount': amount, 'amount': amount, if (note != null) 'note': note},
    );
    final data = response.data as Map<String, dynamic>;
    return SavingsGoalModel.fromJson(data);
  }

  @override
  Future<void> deleteSavingsGoal(String id) async {
    await _apiClient.delete('/finance/savings-goals/$id');
  }

  @override
  Future<List<InvestmentModel>> getInvestments() async {
    try {
      final response = await _apiClient.get('/finance/investments');
      final list = _extractList(response.data);
      final remote = list.map((e) => InvestmentModel.fromJson(e as Map<String, dynamic>)).toList();
      _localInvestmentsCache.clear();
      _localInvestmentsCache.addAll(remote);
      return remote;
    } catch (_) {
      return List.unmodifiable(_localInvestmentsCache);
    }
  }

  @override
  Future<InvestmentModel> createInvestment(InvestmentModel investment) async {
    try {
      final response = await _apiClient.post('/finance/investments', data: investment.toJson());
      final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
          ? response.data['data']
          : response.data;
      final created = InvestmentModel.fromJson(data as Map<String, dynamic>);
      _localInvestmentsCache.add(created);
      return created;
    } catch (_) {
      _localInvestmentsCache.removeWhere((i) => i.id == investment.id);
      _localInvestmentsCache.add(investment);
      return investment;
    }
  }

  @override
  Future<InvestmentModel> updateInvestment(InvestmentModel investment) async {
    try {
      final response = await _apiClient.patch('/finance/investments/${investment.id}', data: investment.toJson());
      final data = response.data as Map<String, dynamic>;
      final updated = InvestmentModel.fromJson(data);
      final idx = _localInvestmentsCache.indexWhere((i) => i.id == investment.id);
      if (idx != -1) _localInvestmentsCache[idx] = updated;
      return updated;
    } catch (_) {
      final idx = _localInvestmentsCache.indexWhere((i) => i.id == investment.id);
      if (idx != -1) _localInvestmentsCache[idx] = investment;
      return investment;
    }
  }

  @override
  Future<void> deleteInvestment(String id) async {
    try {
      await _apiClient.delete('/finance/investments/$id');
    } catch (_) {}
    _localInvestmentsCache.removeWhere((i) => i.id == id);
  }

  @override
  Future<List<FinanceCategoryModel>> getCategories() async {
    final response = await _apiClient.get('/finance/categories');
    final list = _extractList(response.data);
    return list.map((e) => FinanceCategoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<FinanceCategoryModel> createCategory(FinanceCategoryModel category) async {
    final response = await _apiClient.post('/finance/categories', data: category.toCreateJson());
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return FinanceCategoryModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<TransactionModel>> getTransactions({String? query, String? type}) async {
    try {
      final response = await _apiClient.get(
        '/finance/transactions',
        queryParameters: {
          if (query != null) 'search': query,
          if (type != null) 'type': type,
        },
      );
      final list = _extractList(response.data);
      if (list.isNotEmpty) {
        return list.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // Backend does not expose a unified /finance/transactions endpoint; aggregate expenses and incomes
    }

    final List<TransactionModel> txList = [];
    final upperType = type?.toUpperCase() ?? 'ALL';
    final fetchExpenses = upperType == 'ALL' || upperType == 'EXPENSE';
    final fetchIncomes = upperType == 'ALL' || upperType == 'INCOME';

    if (fetchExpenses) {
      try {
        final expenses = await getExpenses(search: query);
        for (final exp in expenses) {
          txList.add(TransactionModel(
            id: exp.id,
            title: exp.title,
            amount: exp.amount,
            type: TransactionType.expense,
            categoryName: exp.categoryName,
            date: exp.date,
            note: exp.note,
            paymentMethod: exp.paymentMethod,
          ));
        }
      } catch (_) {}
    }

    if (fetchIncomes) {
      try {
        final incomes = await getIncomes();
        for (final inc in incomes) {
          if (query != null &&
              query.isNotEmpty &&
              !inc.title.toLowerCase().contains(query.toLowerCase())) {
            continue;
          }
          txList.add(TransactionModel(
            id: inc.id,
            title: inc.title,
            amount: inc.amount,
            type: TransactionType.income,
            categoryName: inc.sourceCategory,
            date: inc.date,
            note: inc.note,
            paymentMethod: 'CASH',
          ));
        }
      } catch (_) {}
    }

    txList.sort((a, b) => b.date.compareTo(a.date));
    return txList;
  }

  @override
  Future<FinancialReportModel> getFinancialReport(String timeframe) async {
    try {
      final response = await _apiClient.get(
        '/finance/reports',
        queryParameters: {'reportType': timeframe, 'timeframe': timeframe},
      );
      dynamic payload = response.data;
      if (payload is Map<String, dynamic> && payload['data'] != null) {
        payload = payload['data'];
      }
      if (payload is List && payload.isNotEmpty) {
        return FinancialReportModel.fromJson(payload.first as Map<String, dynamic>);
      } else if (payload is Map<String, dynamic>) {
        return FinancialReportModel.fromJson(payload);
      }
    } catch (_) {}

    try {
      final response = await _apiClient.post(
        '/finance/reports/generate',
        data: {'reportType': timeframe, 'format': 'JSON'},
      );
      dynamic payload = response.data;
      if (payload is Map<String, dynamic> && payload['data'] != null) {
        payload = payload['data'];
      }
      if (payload is Map<String, dynamic>) {
        return FinancialReportModel.fromJson(payload);
      }
    } catch (_) {}

    return FinancialReportModel(
      timeframe: timeframe,
      totalIncome: 0.0,
      totalExpense: 0.0,
      netSavings: 0.0,
      savingsRatePercentage: 0.0,
      expenseBreakdown: const [],
      incomeBreakdown: const [],
      cashFlowSeries: const [],
    );
  }
}
