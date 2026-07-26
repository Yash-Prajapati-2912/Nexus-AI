import 'package:equatable/equatable.dart';
import '../../domain/entities/budget.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/income.dart';
import '../../domain/entities/savings_goal.dart';

abstract class FinanceState extends Equatable {
  const FinanceState();

  @override
  List<Object?> get props => [];
}

class FinanceInitialState extends FinanceState {
  const FinanceInitialState();
}

class FinanceLoadingState extends FinanceState {
  const FinanceLoadingState();
}

class FinanceFailureState extends FinanceState {
  final String message;

  const FinanceFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class FinanceLoadedState extends FinanceState {
  final double totalBalance;
  final double monthlyExpenseTotal;
  final double monthlyIncomeTotal;
  final List<Expense> recentExpenses;
  final List<Income> recentIncomes;
  final List<Budget> activeBudgets;
  final List<SavingsGoal> activeGoals;

  const FinanceLoadedState({
    required this.totalBalance,
    required this.monthlyExpenseTotal,
    required this.monthlyIncomeTotal,
    required this.recentExpenses,
    required this.recentIncomes,
    required this.activeBudgets,
    required this.activeGoals,
  });

  @override
  List<Object?> get props => [
        totalBalance,
        monthlyExpenseTotal,
        monthlyIncomeTotal,
        recentExpenses,
        recentIncomes,
        activeBudgets,
        activeGoals,
      ];
}
