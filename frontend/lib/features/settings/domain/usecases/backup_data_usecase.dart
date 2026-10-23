import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/backup_entity.dart';
import '../repositories/i_settings_repository.dart';

class BackupDataUseCase implements UseCase<BackupEntity, NoParams> {
  final ISettingsRepository repository;

  BackupDataUseCase(this.repository);

  @override
  Future<Either<Failure, BackupEntity>> call(NoParams params) {
    return repository.backupData();
  }
}
