import 'package:fpdart/fpdart.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/assignment_entity.dart';
import '../../domain/entities/calendar_event_entity.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/entities/study_session_entity.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/i_planner_repository.dart';
import '../datasources/planner_remote_data_source.dart';
import '../models/assignment_model.dart';
import '../models/study_session_model.dart';
import '../models/task_model.dart';

class PlannerRepositoryImpl implements IPlannerRepository {
  final IPlannerRemoteDataSource _remoteDataSource;

  PlannerRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    try {
      final models = await _remoteDataSource.getTasks();
      return Right(models.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    try {
      final model = await _remoteDataSource.createTask(TaskModel.fromDomain(task));
      return Right(model.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task) async {
    try {
      final model = await _remoteDataSource.updateTask(TaskModel.fromDomain(task));
      return Right(model.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      await _remoteDataSource.deleteTask(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> completeTask(String id) async {
    try {
      final model = await _remoteDataSource.completeTask(id);
      return Right(model.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<AssignmentEntity>>> getAssignments() async {
    try {
      final models = await _remoteDataSource.getAssignments();
      return Right(models.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, AssignmentEntity>> createAssignment(AssignmentEntity assignment) async {
    try {
      final model = await _remoteDataSource.createAssignment(AssignmentModel.fromDomain(assignment));
      return Right(model.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, AssignmentEntity>> updateAssignment(AssignmentEntity assignment) async {
    try {
      final model = await _remoteDataSource.updateAssignment(AssignmentModel.fromDomain(assignment));
      return Right(model.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAssignment(String id) async {
    try {
      await _remoteDataSource.deleteAssignment(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<StudySessionEntity>>> getStudySessions() async {
    try {
      final models = await _remoteDataSource.getStudySessions();
      return Right(models.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, StudySessionEntity>> createStudySession(StudySessionEntity session) async {
    try {
      final model = await _remoteDataSource.createStudySession(StudySessionModel.fromDomain(session));
      return Right(model.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<GoalEntity>>> getGoals() async {
    try {
      final models = await _remoteDataSource.getGoals();
      return Right(models.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<CalendarEventEntity>>> getCalendarEvents() async {
    try {
      final models = await _remoteDataSource.getCalendarEvents();
      return Right(models.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> searchPlanner(String query) async {
    try {
      final models = await _remoteDataSource.searchPlanner(query);
      return Right(models.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
