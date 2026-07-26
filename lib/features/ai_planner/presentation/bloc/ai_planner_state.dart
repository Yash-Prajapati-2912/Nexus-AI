import 'package:equatable/equatable.dart';
import '../../domain/entities/ai_history_item.dart';
import '../../domain/entities/deadline_risk.dart';
import '../../domain/entities/priority_optimizer.dart';
import '../../domain/entities/productivity_insight.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/entities/study_plan.dart';
import '../../domain/entities/workload_analysis.dart';

abstract class AIPlannerState extends Equatable {
  const AIPlannerState();

  @override
  List<Object?> get props => [];
}

class AIPlannerInitialState extends AIPlannerState {
  const AIPlannerInitialState();
}

class AIPlannerLoadingState extends AIPlannerState {
  final String? loadingMessage;

  const AIPlannerLoadingState({this.loadingMessage});

  @override
  List<Object?> get props => [loadingMessage];
}

class AIPlannerRefreshingState extends AIPlannerState {
  const AIPlannerRefreshingState();
}

class AIPlannerEmptyState extends AIPlannerState {
  final String message;

  const AIPlannerEmptyState({required this.message});

  @override
  List<Object?> get props => [message];
}

class AIPlannerFailureState extends AIPlannerState {
  final String message;
  final int? statusCode;

  const AIPlannerFailureState({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class AIPlannerLoadedState extends AIPlannerState {
  final StudyPlan? currentStudyPlan;
  final WorkloadAnalysis? workloadAnalysis;
  final PriorityOptimizer? priorityOptimizer;
  final DeadlineRisk? deadlineRisk;
  final ProductivityInsight? productivityInsight;
  final List<Recommendation> recommendations;
  final List<AIHistoryItem> historyItems;
  final List<StudyPlan> savedPlans;
  final String? exportMessage;

  const AIPlannerLoadedState({
    this.currentStudyPlan,
    this.workloadAnalysis,
    this.priorityOptimizer,
    this.deadlineRisk,
    this.productivityInsight,
    this.recommendations = const [],
    this.historyItems = const [],
    this.savedPlans = const [],
    this.exportMessage,
  });

  AIPlannerLoadedState copyWith({
    StudyPlan? currentStudyPlan,
    WorkloadAnalysis? workloadAnalysis,
    PriorityOptimizer? priorityOptimizer,
    DeadlineRisk? deadlineRisk,
    ProductivityInsight? productivityInsight,
    List<Recommendation>? recommendations,
    List<AIHistoryItem>? historyItems,
    List<StudyPlan>? savedPlans,
    String? exportMessage,
  }) {
    return AIPlannerLoadedState(
      currentStudyPlan: currentStudyPlan ?? this.currentStudyPlan,
      workloadAnalysis: workloadAnalysis ?? this.workloadAnalysis,
      priorityOptimizer: priorityOptimizer ?? this.priorityOptimizer,
      deadlineRisk: deadlineRisk ?? this.deadlineRisk,
      productivityInsight: productivityInsight ?? this.productivityInsight,
      recommendations: recommendations ?? this.recommendations,
      historyItems: historyItems ?? this.historyItems,
      savedPlans: savedPlans ?? this.savedPlans,
      exportMessage: exportMessage,
    );
  }

  @override
  List<Object?> get props => [
        currentStudyPlan,
        workloadAnalysis,
        priorityOptimizer,
        deadlineRisk,
        productivityInsight,
        recommendations,
        historyItems,
        savedPlans,
        exportMessage,
      ];
}
