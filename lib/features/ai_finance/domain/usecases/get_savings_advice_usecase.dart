import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/savings_recommendation.dart';
import 'package:nexus_ai/features/ai_finance/domain/repositories/i_ai_finance_repository.dart';

class GetSavingsAdviceUseCase implements UseCase<SavingsRecommendation, NoParams> {
  final IAIFinanceRepository repository;

  GetSavingsAdviceUseCase(this.repository);

  @override
  Future<Either<Failure, SavingsRecommendation>> call(NoParams params) {
    return repository.getSavingsAdvice();
  }
}
