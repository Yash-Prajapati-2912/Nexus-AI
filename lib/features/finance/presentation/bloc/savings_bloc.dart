import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../../domain/usecases/get_savings_goals_usecase.dart';
import 'package:nexus_ai/features/finance/domain/repositories/i_finance_repository.dart';

import 'savings_event.dart';
import 'savings_state.dart';

class SavingsBloc extends Bloc<SavingsEvent, SavingsState> {
  final GetSavingsGoalsUseCase getSavingsGoalsUseCase;
  final IFinanceRepository repository;

  SavingsBloc({
    required this.getSavingsGoalsUseCase,
    required this.repository,
  }) : super(const SavingsInitialState()) {
    on<LoadSavingsGoalsEvent>(_onLoadGoals);
    on<CreateSavingsGoalEvent>(_onCreateGoal);
    on<AddSavingsContributionEvent>(_onAddContribution);
    on<DeleteSavingsGoalEvent>(_onDeleteGoal);
  }

  Future<void> _onLoadGoals(
    LoadSavingsGoalsEvent event,
    Emitter<SavingsState> emit,
  ) async {
    emit(const SavingsLoadingState());
    final result = await getSavingsGoalsUseCase(const NoParams());

    result.fold(
      (Failure f) => emit(SavingsFailureState(message: f.message)),
      (goals) => emit(SavingsLoadedState(goals: goals)),
    );
  }

  Future<void> _onCreateGoal(
    CreateSavingsGoalEvent event,
    Emitter<SavingsState> emit,
  ) async {
    emit(const SavingsLoadingState());
    final result = await repository.createSavingsGoal(event.goal);

    result.fold(
      (Failure f) => emit(SavingsFailureState(message: f.message)),
      (goal) => emit(const SavingsOperationSuccessState(message: 'Savings goal created successfully.')),
    );
  }

  Future<void> _onAddContribution(
    AddSavingsContributionEvent event,
    Emitter<SavingsState> emit,
  ) async {
    emit(const SavingsLoadingState());
    final result = await repository.addContribution(event.goalId, event.amount, event.note);

    result.fold(
      (Failure f) => emit(SavingsFailureState(message: f.message)),
      (goal) => emit(const SavingsOperationSuccessState(message: 'Contribution added successfully.')),
    );
  }

  Future<void> _onDeleteGoal(
    DeleteSavingsGoalEvent event,
    Emitter<SavingsState> emit,
  ) async {
    emit(const SavingsLoadingState());
    final result = await repository.deleteSavingsGoal(event.id);

    result.fold(
      (Failure f) => emit(SavingsFailureState(message: f.message)),
      (_) => emit(const SavingsOperationSuccessState(message: 'Savings goal deleted.')),
    );
  }
}
