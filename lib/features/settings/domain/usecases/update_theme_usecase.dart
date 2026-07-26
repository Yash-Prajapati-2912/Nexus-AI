import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/theme_entity.dart';
import '../repositories/i_settings_repository.dart';

class UpdateThemeUseCase implements UseCase<ThemeEntity, ThemeEntity> {
  final ISettingsRepository repository;

  UpdateThemeUseCase(this.repository);

  @override
  Future<Either<Failure, ThemeEntity>> call(ThemeEntity params) {
    return repository.updateTheme(params);
  }
}
