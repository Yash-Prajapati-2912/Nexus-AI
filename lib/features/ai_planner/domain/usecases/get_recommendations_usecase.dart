import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/recommendation.dart';
import '../repositories/i_ai_planner_repository.dart';

class GetRecommendationsUseCase implements UseCase<List<Recommendation>, NoParams> {
  final IAIPlannerRepository repository;

  GetRecommendationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Recommendation>>> call(NoParams params) {
    return repository.getRecommendations();
  }
}
