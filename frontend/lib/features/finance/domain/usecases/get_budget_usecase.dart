import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/budget.dart';
import '../repositories/i_finance_repository.dart';

class GetBudgetUseCase implements UseCase<List<Budget>, NoParams> {
  final IFinanceRepository repository;

  GetBudgetUseCase(this.repository);

  @override
  Future<Either<Failure, List<Budget>>> call(NoParams params) {
    return repository.getBudgets();
  }
}
