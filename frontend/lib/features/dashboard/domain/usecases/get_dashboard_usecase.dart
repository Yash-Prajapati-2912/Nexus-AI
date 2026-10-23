import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/i_dashboard_repository.dart';

class GetDashboardUseCase implements UseCase<DashboardEntity, NoParams> {
  final IDashboardRepository repository;

  GetDashboardUseCase(this.repository);

  @override
  Future<Either<Failure, DashboardEntity>> call(NoParams params) async {
    return await repository.getDashboardSummary();
  }
}
