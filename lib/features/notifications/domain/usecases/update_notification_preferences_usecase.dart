import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/notification_preferences.dart';
import '../repositories/i_notification_repository.dart';

class UpdateNotificationPreferencesUseCase implements UseCase<NotificationPreferences, Map<String, dynamic>> {
  final INotificationRepository repository;

  UpdateNotificationPreferencesUseCase(this.repository);

  @override
  Future<Either<Failure, NotificationPreferences>> call(Map<String, dynamic> params) {
    return repository.updatePreferences(params);
  }
}
