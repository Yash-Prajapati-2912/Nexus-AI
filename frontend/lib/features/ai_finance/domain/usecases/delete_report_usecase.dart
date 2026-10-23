import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import 'package:nexus_ai/features/ai_finance/domain/repositories/i_ai_finance_repository.dart';

class DeleteReportUseCase implements UseCase<Unit, String> {
  final IAIFinanceRepository repository;

  DeleteReportUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String reportId) {
    return repository.deleteReport(reportId);
  }
}
