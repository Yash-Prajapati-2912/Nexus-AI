import 'package:equatable/equatable.dart';
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
  const DashboardRefreshingState(this.currentDashboard);

  @override
  List<Object?> get props => [currentDashboard];
}

class DashboardLoadedState extends DashboardState {
  final DashboardEntity dashboard;

  const DashboardLoadedState(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

class DashboardErrorState extends DashboardState {
  final String message;

  const DashboardErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
