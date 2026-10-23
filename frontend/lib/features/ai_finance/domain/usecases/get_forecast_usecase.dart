import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/forecast.dart';
import 'package:nexus_ai/features/ai_finance/domain/repositories/i_ai_finance_repository.dart';

class GetForecastUseCase implements UseCase<Forecast, NoParams> {
  final IAIFinanceRepository repository;

  GetForecastUseCase(this.repository);

  @override
  Future<Either<Failure, Forecast>> call(NoParams params) {
    return repository.getForecast();
  }
}
