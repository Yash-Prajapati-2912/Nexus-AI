import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/workload_analysis.dart';
import '../repositories/i_ai_planner_repository.dart';

class GetWorkloadAnalysisUseCase implements UseCase<WorkloadAnalysis, NoParams> {
  final IAIPlannerRepository repository;

  GetWorkloadAnalysisUseCase(this.repository);

  @override
  Future<Either<Failure, WorkloadAnalysis>> call(NoParams params) {
    return repository.getWorkloadAnalysis();
  }
}
