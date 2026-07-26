import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/budget.dart';
import '../repositories/i_finance_repository.dart';

class UpdateBudgetUseCase implements UseCase<Budget, Budget> {
  final IFinanceRepository repository;

  UpdateBudgetUseCase(this.repository);

  @override
  Future<Either<Failure, Budget>> call(Budget budget) {
    return repository.updateBudget(budget);
  }
}
