import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/budget_recommendation.dart';
import 'package:nexus_ai/features/ai_finance/domain/repositories/i_ai_finance_repository.dart';

class GetBudgetRecommendationsUseCase implements UseCase<BudgetRecommendation, NoParams> {
  final IAIFinanceRepository repository;

  GetBudgetRecommendationsUseCase(this.repository);

  @override
  Future<Either<Failure, BudgetRecommendation>> call(NoParams params) {
    return repository.getBudgetRecommendations();
  }
}
