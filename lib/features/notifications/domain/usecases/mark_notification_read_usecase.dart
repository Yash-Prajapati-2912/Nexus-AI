import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../repositories/i_notification_repository.dart';

class MarkNotificationReadUseCase implements UseCase<Unit, String> {
  final INotificationRepository repository;

  MarkNotificationReadUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String notificationId) {
    return repository.markAsRead(notificationId);
  }
}
