import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/assignment_entity.dart';
import '../entities/calendar_event_entity.dart';
import '../entities/goal_entity.dart';
import '../entities/study_session_entity.dart';
import '../entities/task_entity.dart';

abstract class IPlannerRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks();
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task);
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task);
  Future<Either<Failure, void>> deleteTask(String id);
  Future<Either<Failure, TaskEntity>> completeTask(String id);

  Future<Either<Failure, List<AssignmentEntity>>> getAssignments();
  Future<Either<Failure, AssignmentEntity>> createAssignment(AssignmentEntity assignment);
  Future<Either<Failure, AssignmentEntity>> updateAssignment(AssignmentEntity assignment);
  Future<Either<Failure, void>> deleteAssignment(String id);

  Future<Either<Failure, List<StudySessionEntity>>> getStudySessions();
  Future<Either<Failure, StudySessionEntity>> createStudySession(StudySessionEntity session);

  Future<Either<Failure, List<GoalEntity>>> getGoals();
  Future<Either<Failure, List<CalendarEventEntity>>> getCalendarEvents();
  Future<Either<Failure, List<TaskEntity>>> searchPlanner(String query);
}
