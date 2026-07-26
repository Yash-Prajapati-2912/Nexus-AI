import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/savings_goal.dart';
import '../repositories/i_finance_repository.dart';

class GetSavingsGoalsUseCase implements UseCase<List<SavingsGoal>, NoParams> {
  final IFinanceRepository repository;

  GetSavingsGoalsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SavingsGoal>>> call(NoParams params) {
    return repository.getSavingsGoals();
  }
}
