import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/subscription_analysis.dart';
import 'package:nexus_ai/features/ai_finance/domain/repositories/i_ai_finance_repository.dart';

class GetSubscriptionAnalysisUseCase implements UseCase<SubscriptionAnalysis, NoParams> {
  final IAIFinanceRepository repository;

  GetSubscriptionAnalysisUseCase(this.repository);

  @override
  Future<Either<Failure, SubscriptionAnalysis>> call(NoParams params) {
    return repository.getSubscriptionAnalysis();
  }
}
