import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../../domain/usecases/get_budget_usecase.dart';
import '../../domain/usecases/update_budget_usecase.dart';
import 'package:nexus_ai/features/finance/domain/repositories/i_finance_repository.dart';

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
          final spentInPeriod = expenses.where((e) {
            return e.date.isAfter(b.startDate.subtract(const Duration(seconds: 1))) &&
                e.date.isBefore(b.endDate.add(const Duration(days: 1)));
          }).fold(0.0, (sum, e) => sum + e.amount);

          return b.copyWith(
            currentSpent: spentInPeriod > 0 ? spentInPeriod : b.currentSpent,
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
