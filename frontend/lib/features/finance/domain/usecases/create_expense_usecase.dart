import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/i_finance_repository.dart';

class CreateExpenseUseCase implements UseCase<Expense, Expense> {
  final IFinanceRepository repository;

  CreateExpenseUseCase(this.repository);

  @override
  Future<Either<Failure, Expense>> call(Expense expense) {
    return repository.createExpense(expense);
  }
}
