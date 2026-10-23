import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/user_statistics.dart';
import '../repositories/i_profile_repository.dart';

class LoadStatisticsUseCase implements UseCase<UserStatistics, NoParams> {
  final IProfileRepository repository;

  LoadStatisticsUseCase(this.repository);

  @override
  Future<Either<Failure, UserStatistics>> call(NoParams params) {
    return repository.getStatistics();
  }
}
