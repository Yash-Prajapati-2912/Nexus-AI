import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../repositories/i_notification_repository.dart';

class DeleteNotificationUseCase implements UseCase<Unit, String> {
  final INotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String notificationId) {
    return repository.deleteNotification(notificationId);
  }
}
