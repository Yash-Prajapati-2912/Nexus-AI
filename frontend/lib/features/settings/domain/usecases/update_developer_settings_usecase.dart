import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/developer_settings_entity.dart';
import '../repositories/i_settings_repository.dart';

class UpdateDeveloperSettingsUseCase implements UseCase<DeveloperSettingsEntity, DeveloperSettingsEntity> {
  final ISettingsRepository repository;

  UpdateDeveloperSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, DeveloperSettingsEntity>> call(DeveloperSettingsEntity params) {
    return repository.updateDeveloperSettings(params);
  }
}
