import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/productivity_insight.dart';
import '../repositories/i_ai_planner_repository.dart';

class GetProductivityInsightsUseCase implements UseCase<ProductivityInsight, NoParams> {
  final IAIPlannerRepository repository;

  GetProductivityInsightsUseCase(this.repository);

  @override
  Future<Either<Failure, ProductivityInsight>> call(NoParams params) {
    return repository.getProductivityInsights();
  }
}
