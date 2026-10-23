import 'package:equatable/equatable.dart';
import '../../domain/entities/budget.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object?> get props => [];
}

class BudgetInitialState extends BudgetState {
  const BudgetInitialState();
}

class BudgetLoadingState extends BudgetState {
  const BudgetLoadingState();
}

class BudgetFailureState extends BudgetState {
  final String message;

  const BudgetFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class BudgetLoadedState extends BudgetState {
  final List<Budget> budgets;

  const BudgetLoadedState({required this.budgets});

  @override
  List<Object?> get props => [budgets];
}

class BudgetOperationSuccessState extends BudgetState {
  final String message;

  const BudgetOperationSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}
