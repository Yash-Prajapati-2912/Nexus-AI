import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/notification_item.dart';
import '../repositories/i_notification_repository.dart';

class GetNotificationsParams extends Equatable {
  final int page;
  final int limit;

  const GetNotificationsParams({this.page = 1, this.limit = 20});

  @override
  List<Object?> get props => [page, limit];
}

class GetNotificationsUseCase implements UseCase<List<NotificationItem>, GetNotificationsParams> {
  final INotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NotificationItem>>> call(GetNotificationsParams params) {
    return repository.getNotifications(page: params.page, limit: params.limit);
  }
}
