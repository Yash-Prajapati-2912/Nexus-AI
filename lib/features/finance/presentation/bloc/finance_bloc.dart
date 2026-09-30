import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import 'package:nexus_ai/features/finance/domain/repositories/i_finance_repository.dart';
import '../../domain/usecases/get_budget_usecase.dart';
import '../../domain/usecases/get_expenses_usecase.dart';
import '../../domain/usecases/get_income_usecase.dart';
import '../../domain/usecases/get_savings_goals_usecase.dart';
import '../../utils/finance_date_utils.dart';
import 'finance_event.dart';
import 'finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final GetExpensesUseCase getExpensesUseCase;
  final GetIncomeUseCase getIncomeUseCase;
  final GetBudgetUseCase getBudgetUseCase;
  final GetSavingsGoalsUseCase getSavingsGoalsUseCase;
  final IFinanceRepository repository;

  FinanceBloc({
    required this.getExpensesUseCase,
    required this.getIncomeUseCase,
    required this.getBudgetUseCase,
    required this.getSavingsGoalsUseCase,
    required this.repository,
  }) : super(const FinanceInitialState()) {
    on<LoadFinanceDashboardEvent>(_onLoadDashboard);
    on<RefreshFinanceDashboardEvent>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadFinanceDashboardEvent event,
    Emitter<FinanceState> emit,
  ) async {
    emit(const FinanceLoadingState());

    try {
      final expensesResult = await getExpensesUseCase(const GetExpensesParams());
      final incomeResult = await getIncomeUseCase(const GetIncomeParams());
      final budgetsResult = await getBudgetUseCase(const NoParams());
      final goalsResult = await getSavingsGoalsUseCase(const NoParams());
      final investmentsResult = await repository.getInvestments();

      final expenses = expensesResult.getOrElse((_) => []);
      final incomes = incomeResult.getOrElse((_) => []);
      final rawBudgets = budgetsResult.getOrElse((_) => []);
      final goals = goalsResult.getOrElse((_) => []);
      final investments = investmentsResult.getOrElse((_) => []);

      final double totalExp = expenses.fold(0.0, (sum, item) => sum + item.amount);
      final double totalInc = incomes.fold(0.0, (sum, item) => sum + item.amount);
      final double balance = totalInc - totalExp;

      final updatedBudgets = rawBudgets.map((b) {
        final start = FinanceDateUtils.startOfDay(b.startDate);
        final end = FinanceDateUtils.endOfDay(b.endDate);
        final spentInPeriod = expenses.where((e) {
          final inRange = FinanceDateUtils.isInRange(e.date, start, end);
          final inCat = b.categoryId == null || b.categoryId!.isEmpty || e.categoryId == b.categoryId;
          return inRange && inCat;
        }).fold(0.0, (sum, e) => sum + e.amount);

        return b.copyWith(
          currentSpent: spentInPeriod,
        );
      }).toList();

      emit(FinanceLoadedState(
        totalBalance: balance,
        monthlyExpenseTotal: totalExp,
        monthlyIncomeTotal: totalInc,
        recentExpenses: expenses,
        recentIncomes: incomes,
        activeBudgets: updatedBudgets,
        activeGoals: goals,
        investments: investments,
      ));
    } catch (e) {
      emit(FinanceFailureState(message: e.toString()));
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshFinanceDashboardEvent event,
    Emitter<FinanceState> emit,
  ) async {
    add(const LoadFinanceDashboardEvent());
  }
}
