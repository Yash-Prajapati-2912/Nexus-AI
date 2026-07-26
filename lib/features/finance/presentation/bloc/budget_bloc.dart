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

    result.fold(
      (Failure f) => emit(BudgetFailureState(message: f.message)),
      (budgets) => emit(BudgetLoadedState(budgets: budgets)),
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
