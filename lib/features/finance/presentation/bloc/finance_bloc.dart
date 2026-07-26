import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../../domain/usecases/get_budget_usecase.dart';
import '../../domain/usecases/get_expenses_usecase.dart';
import '../../domain/usecases/get_income_usecase.dart';
import '../../domain/usecases/get_savings_goals_usecase.dart';
import 'finance_event.dart';
import 'finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final GetExpensesUseCase getExpensesUseCase;
  final GetIncomeUseCase getIncomeUseCase;
  final GetBudgetUseCase getBudgetUseCase;
  final GetSavingsGoalsUseCase getSavingsGoalsUseCase;

  FinanceBloc({
    required this.getExpensesUseCase,
    required this.getIncomeUseCase,
    required this.getBudgetUseCase,
    required this.getSavingsGoalsUseCase,
  }) : super(const FinanceInitialState()) {
    on<LoadFinanceDashboardEvent>(_onLoadDashboard);
    on<RefreshFinanceDashboardEvent>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadFinanceDashboardEvent event,
    Emitter<FinanceState> emit,
  ) async {
    emit(const FinanceLoadingState());

    final expensesResult = await getExpensesUseCase(const GetExpensesParams());
    final incomeResult = await getIncomeUseCase(const GetIncomeParams());
    final budgetsResult = await getBudgetUseCase(const NoParams());
    final goalsResult = await getSavingsGoalsUseCase(const NoParams());

    expensesResult.fold(
      (Failure f) => emit(FinanceFailureState(message: f.message)),
      (expenses) {
        incomeResult.fold(
          (Failure f) => emit(FinanceFailureState(message: f.message)),
          (incomes) {
            final double totalExp = expenses.fold(0.0, (sum, item) => sum + item.amount);
            final double totalInc = incomes.fold(0.0, (sum, item) => sum + item.amount);
            final double balance = totalInc - totalExp;

            emit(FinanceLoadedState(
              totalBalance: balance,
              monthlyExpenseTotal: totalExp,
              monthlyIncomeTotal: totalInc,
              recentExpenses: expenses.take(5).toList(),
              recentIncomes: incomes.take(5).toList(),
              activeBudgets: budgetsResult.getOrElse((_) => []),
              activeGoals: goalsResult.getOrElse((_) => []),
            ));
          },
        );
      },
    );
  }

  Future<void> _onRefreshDashboard(
    RefreshFinanceDashboardEvent event,
    Emitter<FinanceState> emit,
  ) async {
    add(const LoadFinanceDashboardEvent());
  }
}
