import 'package:equatable/equatable.dart';
import '../../domain/entities/study_plan.dart';

abstract class AIPlannerEvent extends Equatable {
  const AIPlannerEvent();

  @override
  List<Object?> get props => [];
}

class GeneratePlanEvent extends AIPlannerEvent {
  final String timeframe;
  final List<String>? targetSubjects;
  final int? dailyGoalMinutes;

  const GeneratePlanEvent({
    required this.timeframe,
    this.targetSubjects,
    this.dailyGoalMinutes,
  });

  @override
  List<Object?> get props => [timeframe, targetSubjects, dailyGoalMinutes];
}

class LoadHistoryEvent extends AIPlannerEvent {
  const LoadHistoryEvent();
}

class LoadInsightsEvent extends AIPlannerEvent {
  const LoadInsightsEvent();
}

class LoadRecommendationsEvent extends AIPlannerEvent {
  const LoadRecommendationsEvent();
}

class LoadDeadlineAnalysisEvent extends AIPlannerEvent {
  const LoadDeadlineAnalysisEvent();
}

class LoadWorkloadAnalysisEvent extends AIPlannerEvent {
  const LoadWorkloadAnalysisEvent();
}

class OptimizePrioritiesEvent extends AIPlannerEvent {
  final List<String>? taskIds;

  const OptimizePrioritiesEvent({this.taskIds});

  @override
  List<Object?> get props => [taskIds];
}

class RefreshInsightsEvent extends AIPlannerEvent {
  const RefreshInsightsEvent();
}

class SavePlanEvent extends AIPlannerEvent {
  final StudyPlan plan;

  const SavePlanEvent(this.plan);

  @override
  List<Object?> get props => [plan];
}

class DeletePlanEvent extends AIPlannerEvent {
  final String planId;

  const DeletePlanEvent(this.planId);

  @override
  List<Object?> get props => [planId];
}

class ExportPlanEvent extends AIPlannerEvent {
  final StudyPlan plan;
  final String format; // pdf, markdown, json

  const ExportPlanEvent({required this.plan, required this.format});

  @override
  List<Object?> get props => [plan, format];
}
