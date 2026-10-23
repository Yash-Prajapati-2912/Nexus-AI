import 'package:equatable/equatable.dart';
import '../../domain/entities/assignment_entity.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/entities/study_session_entity.dart';
import '../../domain/entities/task_entity.dart';

abstract class PlannerState extends Equatable {
  const PlannerState();

  @override
  List<Object?> get props => [];
}

class PlannerInitialState extends PlannerState {}

class PlannerLoadingState extends PlannerState {}

class PlannerLoadedState extends PlannerState {
  final List<TaskEntity> tasks;
  final List<AssignmentEntity> assignments;
  final List<StudySessionEntity> sessions;
  final List<GoalEntity> goals;

  const PlannerLoadedState({
    required this.tasks,
    required this.assignments,
    required this.sessions,
    required this.goals,
  });

  @override
  List<Object?> get props => [tasks, assignments, sessions, goals];
}

class PlannerErrorState extends PlannerState {
  final String message;
  const PlannerErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
