import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../../domain/usecases/get_budget_usecase.dart';
import '../../domain/usecases/update_budget_usecase.dart';
import 'package:nexus_ai/features/finance/domain/repositories/i_finance_repository.dart';
import '../../utils/finance_date_utils.dart';

import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final GetBudgetUseCase getBudgetUseCase;
  final UpdateBudgetUseCase updateBudgetUseCase;
  final IFinanceRepository repository;

  BudgetBloc({
    required this.getBudgetUseCase,
    required this.updateBudgetUseCase,
    required this.repository,
  }) : super(const BudgetInitialState()) {
    on<LoadBudgetsEvent>(_onLoadBudgets);
    on<CreateBudgetEvent>(_onCreateBudget);
    on<UpdateBudgetEvent>(_onUpdateBudget);
  }

  Future<void> _onLoadBudgets(
    LoadBudgetsEvent event,
    Emitter<BudgetState> emit,
  ) async {
    emit(const BudgetLoadingState());
    final result = await getBudgetUseCase(const NoParams());
    final expensesResult = await repository.getExpenses();

    final expenses = expensesResult.getOrElse((_) => []);

    result.fold(
      (Failure f) => emit(BudgetFailureState(message: f.message)),
      (budgets) {
        final updatedBudgets = budgets.map((b) {
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

        emit(BudgetLoadedState(budgets: updatedBudgets));
      },
    );
  }

  Future<void> _onCreateBudget(
    CreateBudgetEvent event,
    Emitter<BudgetState> emit,
  ) async {
    emit(const BudgetLoadingState());
    final result = await repository.createBudget(event.budget);

    result.fold(
      (Failure f) => emit(BudgetFailureState(message: f.message)),
      (budget) => emit(const BudgetOperationSuccessState(message: 'Budget created successfully.')),
    );
  }

  Future<void> _onUpdateBudget(
    UpdateBudgetEvent event,
    Emitter<BudgetState> emit,
  ) async {
    emit(const BudgetLoadingState());
    final result = await updateBudgetUseCase(event.budget);

    result.fold(
      (Failure f) => emit(BudgetFailureState(message: f.message)),
      (budget) => emit(const BudgetOperationSuccessState(message: 'Budget updated successfully.')),
    );
  }
}
