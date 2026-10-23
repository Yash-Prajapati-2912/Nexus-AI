import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/financial_report.dart';
import '../repositories/i_finance_repository.dart';

class GenerateReportUseCase implements UseCase<FinancialReport, String> {
  final IFinanceRepository repository;

  GenerateReportUseCase(this.repository);

  @override
  Future<Either<Failure, FinancialReport>> call(String timeframe) {
    return repository.getFinancialReport(timeframe);
  }
}
