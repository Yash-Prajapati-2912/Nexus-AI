import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_settings_repository.dart';

class EnableBiometricUseCase implements UseCase<bool, bool> {
  final ISettingsRepository repository;

  EnableBiometricUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(bool enable) {
    return repository.enableBiometric(enable);
  }
}
