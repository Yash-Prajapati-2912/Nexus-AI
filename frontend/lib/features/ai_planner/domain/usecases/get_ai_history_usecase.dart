import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/ai_history_item.dart';
import '../repositories/i_ai_planner_repository.dart';

class GetAIHistoryUseCase implements UseCase<List<AIHistoryItem>, NoParams> {
  final IAIPlannerRepository repository;

  GetAIHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<AIHistoryItem>>> call(NoParams params) {
    return repository.getAIHistory();
  }
}
