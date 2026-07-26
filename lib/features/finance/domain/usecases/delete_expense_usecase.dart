import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../repositories/i_finance_repository.dart';

class DeleteExpenseUseCase implements UseCase<Unit, String> {
  final IFinanceRepository repository;

  DeleteExpenseUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteExpense(id);
  }
}
