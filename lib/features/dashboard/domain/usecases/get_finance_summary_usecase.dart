import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/finance_summary_entity.dart';
import '../repositories/i_dashboard_repository.dart';

class GetFinanceSummaryUseCase implements UseCase<FinanceSummaryEntity, NoParams> {
  final IDashboardRepository repository;

  GetFinanceSummaryUseCase(this.repository);

  @override
  Future<Either<Failure, FinanceSummaryEntity>> call(NoParams params) async {
    return await repository.getFinanceSummary();
  }
}
