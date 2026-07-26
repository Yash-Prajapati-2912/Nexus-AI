import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

abstract class PlannerEvent extends Equatable {
  const PlannerEvent();

  @override
  List<Object?> get props => [];
}

class LoadPlannerEvent extends PlannerEvent {}

class CreateTaskEvent extends PlannerEvent {
  final TaskEntity task;
  const CreateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class ToggleTaskCompletionEvent extends PlannerEvent {
  final String taskId;
  const ToggleTaskCompletionEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class DeleteTaskEvent extends PlannerEvent {
  final String taskId;
  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class SearchPlannerEvent extends PlannerEvent {
  final String query;
  const SearchPlannerEvent(this.query);

  @override
  List<Object?> get props => [query];
}
