import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/activity_item.dart';
import '../repositories/i_notification_repository.dart';

class GetActivityUseCase implements UseCase<List<ActivityItem>, NoParams> {
  final INotificationRepository repository;

  GetActivityUseCase(this.repository);

  @override
  Future<Either<Failure, List<ActivityItem>>> call(NoParams params) {
    return repository.getActivityTimeline();
  }
}
