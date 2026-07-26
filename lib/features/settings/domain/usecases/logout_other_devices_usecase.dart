import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_settings_repository.dart';

class LogoutOtherDevicesUseCase implements UseCase<bool, NoParams> {
  final ISettingsRepository repository;

  LogoutOtherDevicesUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.logoutOtherDevices();
  }
}
