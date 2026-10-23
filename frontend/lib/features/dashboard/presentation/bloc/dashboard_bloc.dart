import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../finance/domain/entities/budget.dart';
import '../../../finance/domain/entities/expense.dart';
import '../../../finance/domain/entities/income.dart';
import '../../../finance/domain/entities/savings_goal.dart';
import '../../../finance/domain/usecases/get_budget_usecase.dart';
import '../../../finance/domain/usecases/get_expenses_usecase.dart';
import '../../../finance/domain/usecases/get_income_usecase.dart';
import '../../../finance/domain/usecases/get_savings_goals_usecase.dart';
import '../../../planner/domain/entities/task_entity.dart';
import '../../../planner/domain/usecases/get_planner_usecase.dart';
import '../../domain/entities/chart_data_entity.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/entities/finance_summary_entity.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase _getDashboardUseCase;
  final GetPlannerUseCase _getPlannerUseCase;
  final GetExpensesUseCase _getExpensesUseCase;
  final GetIncomeUseCase _getIncomeUseCase;
  final GetBudgetUseCase _getBudgetUseCase;
  final GetSavingsGoalsUseCase _getSavingsGoalsUseCase;

  DashboardBloc({
    required GetDashboardUseCase getDashboardUseCase,
    required GetPlannerUseCase getPlannerUseCase,
    required GetExpensesUseCase getExpensesUseCase,
    required GetIncomeUseCase getIncomeUseCase,
    required GetBudgetUseCase getBudgetUseCase,
    required GetSavingsGoalsUseCase getSavingsGoalsUseCase,
  })  : _getDashboardUseCase = getDashboardUseCase,
        _getPlannerUseCase = getPlannerUseCase,
        _getExpensesUseCase = getExpensesUseCase,
        _getIncomeUseCase = getIncomeUseCase,
        _getBudgetUseCase = getBudgetUseCase,
        _getSavingsGoalsUseCase = getSavingsGoalsUseCase,
        super(DashboardInitialState()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<RefreshDashboardEvent>(_onRefreshDashboard);
    on<RetryLoadDashboardEvent>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
    DashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoadingState());
    await _fetchAndEmitDashboard(emit);
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoadedState) {
      final current = (state as DashboardLoadedState).dashboard;
      final currentTasks = (state as DashboardLoadedState).tasks;
      emit(DashboardRefreshingState(current, currentTasks: currentTasks));
    }
    await _fetchAndEmitDashboard(emit);
  }

  Future<void> _fetchAndEmitDashboard(Emitter<DashboardState> emit) async {
    final results = await Future.wait([
      _getDashboardUseCase(const NoParams()),
      _getPlannerUseCase(const NoParams()),
      _getExpensesUseCase(const GetExpensesParams()),
      _getIncomeUseCase(const GetIncomeParams()),
      _getBudgetUseCase(const NoParams()),
      _getSavingsGoalsUseCase(const NoParams()),
    ]);

    final dashboardResult = results[0] as Either<Failure, DashboardEntity>;
    final tasksResult = results[1] as Either<Failure, List<TaskEntity>>;
    final expensesResult = results[2] as Either<Failure, List<Expense>>;
    final incomeResult = results[3] as Either<Failure, List<Income>>;
    final budgetsResult = results[4] as Either<Failure, List<Budget>>;
    final goalsResult = results[5] as Either<Failure, List<SavingsGoal>>;

    dashboardResult.fold(
      (failure) => emit(DashboardErrorState(failure.message)),
      (rawDashboard) {
        final tasks = tasksResult.getOrElse((_) => <TaskEntity>[]);
        final expenses = expensesResult.getOrElse((_) => <Expense>[]);
        final incomes = incomeResult.getOrElse((_) => <Income>[]);
        final budgets = budgetsResult.getOrElse((_) => <Budget>[]);
        final goals = goalsResult.getOrElse((_) => <SavingsGoal>[]);

        final enrichedDashboard = _enrichWithFinanceData(
          rawDashboard,
          expenses: expenses,
          incomes: incomes,
          budgets: budgets,
          goals: goals,
        );

        emit(DashboardLoadedState(enrichedDashboard, tasks: tasks));
      },
    );
  }

  DashboardEntity _enrichWithFinanceData(
    DashboardEntity dashboard, {
    required List<Expense> expenses,
    required List<Income> incomes,
    required List<Budget> budgets,
    required List<SavingsGoal> goals,
  }) {
    // 1. Canonical totals calculation identical to FinanceBloc
    final double totalExpenses = expenses.fold(0.0, (sum, item) => sum + item.amount);
    final double totalIncome = incomes.fold(0.0, (sum, item) => sum + item.amount);
    final double netBalance = totalIncome - totalExpenses;

    // 2. Budget Health calculation
    final double monthlyBudget = budgets.fold(0.0, (sum, item) => sum + item.totalLimit);
    final double remainingBudget = monthlyBudget > 0 ? (monthlyBudget - totalExpenses) : 0.0;

    // 3. Today's expenses
    final now = DateTime.now();
    final double todayExpenses = expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month && e.date.day == now.day)
        .fold(0.0, (sum, item) => sum + item.amount);

    // 4. Savings Goal progress
    final totalTarget = goals.fold(0.0, (sum, g) => sum + g.targetAmount);
    final totalCurrent = goals.fold(0.0, (sum, g) => sum + g.currentAmount);
    final savingsProgress = totalTarget > 0 ? ((totalCurrent / totalTarget) * 100).clamp(0.0, 100.0) : 0.0;
    final activeGoal = goals.where((g) => !g.isAchieved).firstOrNull ?? goals.firstOrNull;

    // 5. Recent transactions unified feed
    final List<FinanceTransactionEntity> allTx = [
      ...expenses.map((e) => FinanceTransactionEntity(
            id: e.id,
            title: e.title,
            amount: e.amount,
            categoryName: e.categoryName.isNotEmpty ? e.categoryName : 'General',
            categoryColour: '#EF4444',
            date: e.date,
            isExpense: true,
          )),
      ...incomes.map((i) => FinanceTransactionEntity(
            id: i.id,
            title: i.title,
            amount: i.amount,
            categoryName: i.sourceCategory.isNotEmpty ? i.sourceCategory : 'Income',
            categoryColour: '#10B981',
            date: i.date,
            isExpense: false,
          )),
    ]..sort((a, b) => b.date.compareTo(a.date));

    // 6. Category Expenses for visualization
    final Map<String, double> categorySums = {};
    for (final exp in expenses) {
      final cat = exp.categoryName.isNotEmpty ? exp.categoryName : 'General';
      categorySums[cat] = (categorySums[cat] ?? 0.0) + exp.amount;
    }
    final categoryChartPoints = categorySums.entries
        .map((e) => ChartDataPoint(label: e.key, value: e.value))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // 7. Non-hallucinated AI insight synthesis
    String? aiTip = dashboard.financeSummary.aiFinancialTip;
    if (aiTip == null || aiTip.isEmpty) {
      if (monthlyBudget > 0 && totalExpenses > monthlyBudget) {
        aiTip =
            'You have exceeded your monthly budget of ₹${monthlyBudget.toStringAsFixed(0)} by ₹${(totalExpenses - monthlyBudget).toStringAsFixed(0)}. Pace remaining spending.';
      } else if (totalIncome > 0 && totalExpenses > 0) {
        if (netBalance >= 0) {
          aiTip =
              'Your net cash flow is positive with a surplus of ₹${netBalance.toStringAsFixed(0)} this month.';
        } else {
          aiTip =
              'Your monthly spending exceeds income by ₹${netBalance.abs().toStringAsFixed(0)}. Review discretionary expenses.';
        }
      } else if (totalIncome > 0) {
        aiTip =
            'You have recorded ₹${totalIncome.toStringAsFixed(0)} in income this month. Set a monthly budget to plan your savings.';
      } else if (totalExpenses > 0) {
        aiTip =
            'You have recorded ₹${totalExpenses.toStringAsFixed(0)} in monthly spending. Log your income to track net balance.';
      }
    }

    final hasRealFinanceData = expenses.isNotEmpty || incomes.isNotEmpty || budgets.isNotEmpty || goals.isNotEmpty;

    final resolvedFinanceSummary = hasRealFinanceData
        ? FinanceSummaryEntity(
            monthlyBudget: monthlyBudget,
            spentThisMonth: totalExpenses,
            remainingBudget: remainingBudget,
            todayExpenses: todayExpenses,
            savingsGoalProgress: savingsProgress,
            totalIncome: totalIncome,
            netBalance: netBalance,
            activeGoalTitle: activeGoal?.title,
            activeGoalTarget: activeGoal?.targetAmount ?? 0.0,
            activeGoalCurrent: activeGoal?.currentAmount ?? 0.0,
            recentTransactions: allTx.take(5).toList(),
            aiFinancialTip: aiTip,
          )
        : dashboard.financeSummary;

    final resolvedChartData = dashboard.chartData.copyWith(
      categoryExpenses: categoryChartPoints.isNotEmpty
          ? categoryChartPoints
          : dashboard.chartData.categoryExpenses,
    );

    return dashboard.copyWith(
      financeSummary: resolvedFinanceSummary,
      chartData: resolvedChartData,
    );
  }
}
