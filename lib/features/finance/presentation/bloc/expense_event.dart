import 'package:equatable/equatable.dart';
import '../../domain/entities/expense.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpensesEvent extends ExpenseEvent {
  final String? categoryId;
  final String? startDate;
  final String? endDate;
  final double? minAmount;
  final double? maxAmount;
  final String? search;

  const LoadExpensesEvent({
    this.categoryId,
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
    this.search,
  });

  @override
  List<Object?> get props => [categoryId, startDate, endDate, minAmount, maxAmount, search];
}

class CreateExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const CreateExpenseEvent(this.expense);

  @override
  List<Object?> get props => [expense];
}

class UpdateExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const UpdateExpenseEvent(this.expense);

  @override
  List<Object?> get props => [expense];
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String id;

  const DeleteExpenseEvent(this.id);

  @override
  List<Object?> get props => [id];
}
