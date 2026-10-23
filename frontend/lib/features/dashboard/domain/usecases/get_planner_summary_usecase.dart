import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/planner_summary_entity.dart';
import '../repositories/i_dashboard_repository.dart';

class GetPlannerSummaryUseCase implements UseCase<PlannerSummaryEntity, NoParams> {
  final IDashboardRepository repository;

  GetPlannerSummaryUseCase(this.repository);

  @override
  Future<Either<Failure, PlannerSummaryEntity>> call(NoParams params) async {
    return await repository.getPlannerSummary();
  }
}
