import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/usecases/create_expense_usecase.dart';
import '../../domain/usecases/delete_expense_usecase.dart';
import '../../domain/usecases/get_expenses_usecase.dart';
import '../../domain/usecases/update_expense_usecase.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetExpensesUseCase getExpensesUseCase;
  final CreateExpenseUseCase createExpenseUseCase;
  final UpdateExpenseUseCase updateExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;

  ExpenseBloc({
    required this.getExpensesUseCase,
    required this.createExpenseUseCase,
    required this.updateExpenseUseCase,
    required this.deleteExpenseUseCase,
  }) : super(const ExpenseInitialState()) {
    on<LoadExpensesEvent>(_onLoadExpenses);
    on<CreateExpenseEvent>(_onCreateExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
  }

  Future<void> _onLoadExpenses(
    LoadExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoadingState());
    final result = await getExpensesUseCase(GetExpensesParams(
      categoryId: event.categoryId,
      startDate: event.startDate,
      endDate: event.endDate,
      minAmount: event.minAmount,
      maxAmount: event.maxAmount,
      search: event.search,
    ));

    result.fold(
      (Failure f) => emit(ExpenseFailureState(message: f.message)),
      (expenses) => emit(ExpenseLoadedState(expenses: expenses)),
    );
  }

  Future<void> _onCreateExpense(
    CreateExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoadingState());
    final result = await createExpenseUseCase(event.expense);

    result.fold(
      (Failure f) => emit(ExpenseFailureState(message: f.message)),
      (expense) => emit(const ExpenseOperationSuccessState(message: 'Expense created successfully.')),
    );
  }

  Future<void> _onUpdateExpense(
    UpdateExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoadingState());
    final result = await updateExpenseUseCase(event.expense);

    result.fold(
      (Failure f) => emit(ExpenseFailureState(message: f.message)),
      (expense) => emit(const ExpenseOperationSuccessState(message: 'Expense updated successfully.')),
    );
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoadingState());
    final result = await deleteExpenseUseCase(event.id);

    result.fold(
      (Failure f) => emit(ExpenseFailureState(message: f.message)),
      (_) => emit(const ExpenseOperationSuccessState(message: 'Expense deleted successfully.')),
    );
  }
}
