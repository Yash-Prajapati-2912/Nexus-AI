import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ai_preferences_entity.dart';
import '../entities/notification_preference_entity.dart';
import '../entities/privacy_entity.dart';
import '../entities/security_entity.dart';
import '../repositories/i_settings_repository.dart';

class UpdatePreferencesParams extends Equatable {
  final AIPreferencesEntity? aiPreferences;
  final NotificationPreferenceEntity? notificationPreferences;
  final PrivacyEntity? privacy;
  final SecurityEntity? security;

  const UpdatePreferencesParams({
    this.aiPreferences,
    this.notificationPreferences,
    this.privacy,
    this.security,
  });

  @override
  List<Object?> get props => [aiPreferences, notificationPreferences, privacy, security];
}

class UpdatePreferencesUseCase implements UseCase<bool, UpdatePreferencesParams> {
  final ISettingsRepository repository;

  UpdatePreferencesUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdatePreferencesParams params) async {
    if (params.aiPreferences != null) {
      final res = await repository.updateAIPreferences(params.aiPreferences!);
      if (res.isLeft()) return res.map((_) => false);
    }
    if (params.notificationPreferences != null) {
      final res = await repository.updateNotificationPreferences(params.notificationPreferences!);
      if (res.isLeft()) return res.map((_) => false);
    }
    if (params.privacy != null) {
      final res = await repository.updatePrivacy(params.privacy!);
      if (res.isLeft()) return res.map((_) => false);
    }
    if (params.security != null) {
      final res = await repository.updateSecurity(params.security!);
      if (res.isLeft()) return res.map((_) => false);
    }
    return const Right(true);
  }
}
