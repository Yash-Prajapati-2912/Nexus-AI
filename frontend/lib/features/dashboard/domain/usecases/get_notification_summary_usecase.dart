import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notification_summary_entity.dart';
import '../repositories/i_dashboard_repository.dart';

class GetNotificationSummaryUseCase implements UseCase<NotificationSummaryEntity, NoParams> {
  final IDashboardRepository repository;

  GetNotificationSummaryUseCase(this.repository);

  @override
  Future<Either<Failure, NotificationSummaryEntity>> call(NoParams params) async {
    return await repository.getNotificationSummary();
  }
}
