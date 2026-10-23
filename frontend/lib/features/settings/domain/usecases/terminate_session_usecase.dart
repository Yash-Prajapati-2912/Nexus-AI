import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_settings_repository.dart';

class TerminateSessionUseCase implements UseCase<bool, String> {
  final ISettingsRepository repository;

  TerminateSessionUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String sessionId) {
    return repository.terminateSession(sessionId);
  }
}
