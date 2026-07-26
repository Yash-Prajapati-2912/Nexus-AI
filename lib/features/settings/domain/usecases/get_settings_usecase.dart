import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/settings_entity.dart';
import '../repositories/i_settings_repository.dart';

class GetSettingsUseCase implements UseCase<SettingsEntity, NoParams> {
  final ISettingsRepository repository;

  GetSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, SettingsEntity>> call(NoParams params) {
    return repository.getSettings();
  }
}
