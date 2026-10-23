import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/calendar_event_entity.dart';
import '../repositories/i_planner_repository.dart';

class GetCalendarEventsUseCase implements UseCase<List<CalendarEventEntity>, NoParams> {
  final IPlannerRepository repository;

  GetCalendarEventsUseCase(this.repository);

  @override
  Future<Either<Failure, List<CalendarEventEntity>>> call(NoParams params) async {
    return await repository.getCalendarEvents();
  }
}
