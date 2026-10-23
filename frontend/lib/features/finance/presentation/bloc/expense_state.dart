import 'package:equatable/equatable.dart';
import '../../domain/entities/expense.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

class ExpenseInitialState extends ExpenseState {
  const ExpenseInitialState();
}

class ExpenseLoadingState extends ExpenseState {
  const ExpenseLoadingState();
}

class ExpenseFailureState extends ExpenseState {
  final String message;

  const ExpenseFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ExpenseLoadedState extends ExpenseState {
  final List<Expense> expenses;

  const ExpenseLoadedState({required this.expenses});

  @override
  List<Object?> get props => [expenses];
}

class ExpenseOperationSuccessState extends ExpenseState {
  final String message;

  const ExpenseOperationSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}
