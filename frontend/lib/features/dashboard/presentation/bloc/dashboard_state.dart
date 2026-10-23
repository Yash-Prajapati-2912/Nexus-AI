import 'package:equatable/equatable.dart';
import '../../../planner/domain/entities/task_entity.dart';
import '../../domain/entities/dashboard_entity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitialState extends DashboardState {}

class DashboardLoadingState extends DashboardState {}

class DashboardRefreshingState extends DashboardState {
  final DashboardEntity currentDashboard;
  final List<TaskEntity> currentTasks;

  const DashboardRefreshingState(this.currentDashboard, {this.currentTasks = const []});

  @override
  List<Object?> get props => [currentDashboard, currentTasks];
}

class DashboardLoadedState extends DashboardState {
  final DashboardEntity dashboard;
  final List<TaskEntity> tasks;

  const DashboardLoadedState(this.dashboard, {this.tasks = const []});

  @override
  List<Object?> get props => [dashboard, tasks];
}

class DashboardErrorState extends DashboardState {
  final String message;

  const DashboardErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
