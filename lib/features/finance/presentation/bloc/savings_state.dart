import 'package:equatable/equatable.dart';
import '../../domain/entities/savings_goal.dart';

abstract class SavingsState extends Equatable {
  const SavingsState();

  @override
  List<Object?> get props => [];
}

class SavingsInitialState extends SavingsState {
  const SavingsInitialState();
}

class SavingsLoadingState extends SavingsState {
  const SavingsLoadingState();
}

class SavingsFailureState extends SavingsState {
  final String message;

  const SavingsFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class SavingsLoadedState extends SavingsState {
  final List<SavingsGoal> goals;

  const SavingsLoadedState({required this.goals});

  @override
  List<Object?> get props => [goals];
}

class SavingsOperationSuccessState extends SavingsState {
  final String message;

  const SavingsOperationSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}
