import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/financial_health.dart';
import 'package:nexus_ai/features/ai_finance/domain/repositories/i_ai_finance_repository.dart';

class GetFinancialHealthUseCase implements UseCase<FinancialHealth, NoParams> {
  final IAIFinanceRepository repository;

  GetFinancialHealthUseCase(this.repository);

  @override
  Future<Either<Failure, FinancialHealth>> call(NoParams params) {
    return repository.getFinancialHealth();
  }
}
