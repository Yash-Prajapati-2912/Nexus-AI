import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/income.dart';
import '../repositories/i_finance_repository.dart';

class CreateIncomeUseCase implements UseCase<Income, Income> {
  final IFinanceRepository repository;

  CreateIncomeUseCase(this.repository);

  @override
  Future<Either<Failure, Income>> call(Income income) {
    return repository.createIncome(income);
  }
}
