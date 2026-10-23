import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/spending_insight.dart';
import 'package:nexus_ai/features/ai_finance/domain/repositories/i_ai_finance_repository.dart';

class GetSpendingInsightsUseCase implements UseCase<SpendingInsight, NoParams> {
  final IAIFinanceRepository repository;

  GetSpendingInsightsUseCase(this.repository);

  @override
  Future<Either<Failure, SpendingInsight>> call(NoParams params) {
    return repository.getSpendingInsights();
  }
}
