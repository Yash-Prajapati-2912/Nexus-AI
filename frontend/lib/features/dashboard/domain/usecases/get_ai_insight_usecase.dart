import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ai_insight_entity.dart';
import '../repositories/i_dashboard_repository.dart';

class GetAiInsightUseCase implements UseCase<AiInsightEntity, NoParams> {
  final IDashboardRepository repository;

  GetAiInsightUseCase(this.repository);

  @override
  Future<Either<Failure, AiInsightEntity>> call(NoParams params) async {
    return await repository.getAiInsights();
  }
}
