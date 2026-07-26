import 'package:equatable/equatable.dart';
import '../../domain/entities/income.dart';

abstract class IncomeState extends Equatable {
  const IncomeState();

  @override
  List<Object?> get props => [];
}

class IncomeInitialState extends IncomeState {
  const IncomeInitialState();
}

class IncomeLoadingState extends IncomeState {
  const IncomeLoadingState();
}

class IncomeFailureState extends IncomeState {
  final String message;

  const IncomeFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class IncomeLoadedState extends IncomeState {
  final List<Income> incomes;

  const IncomeLoadedState({required this.incomes});

  @override
  List<Object?> get props => [incomes];
}

class IncomeOperationSuccessState extends IncomeState {
  final String message;

  const IncomeOperationSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}
