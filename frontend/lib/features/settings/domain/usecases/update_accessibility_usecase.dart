import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/accessibility_entity.dart';
import '../repositories/i_settings_repository.dart';

class UpdateAccessibilityUseCase implements UseCase<AccessibilityEntity, AccessibilityEntity> {
  final ISettingsRepository repository;

  UpdateAccessibilityUseCase(this.repository);

  @override
  Future<Either<Failure, AccessibilityEntity>> call(AccessibilityEntity params) {
    return repository.updateAccessibility(params);
  }
}
