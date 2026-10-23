import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/backup_entity.dart';
import '../repositories/i_settings_repository.dart';

class RestoreDataUseCase implements UseCase<BackupEntity, String> {
  final ISettingsRepository repository;

  RestoreDataUseCase(this.repository);

  @override
  Future<Either<Failure, BackupEntity>> call(String backupId) {
    return repository.restoreData(backupId);
  }
}
