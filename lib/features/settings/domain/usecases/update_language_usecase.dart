import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/language_entity.dart';
import '../repositories/i_settings_repository.dart';

class UpdateLanguageUseCase implements UseCase<LanguageEntity, LanguageEntity> {
  final ISettingsRepository repository;

  UpdateLanguageUseCase(this.repository);

  @override
  Future<Either<Failure, LanguageEntity>> call(LanguageEntity params) {
    return repository.updateLanguage(params);
  }
}
