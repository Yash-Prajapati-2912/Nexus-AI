import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../../domain/repositories/i_ai_planner_repository.dart';
import '../../domain/usecases/delete_plan_usecase.dart';
import '../../domain/usecases/generate_study_plan_usecase.dart';
import '../../domain/usecases/get_ai_history_usecase.dart';
import '../../domain/usecases/get_productivity_insights_usecase.dart';
import '../../domain/usecases/get_recommendations_usecase.dart';
import '../../domain/usecases/get_workload_analysis_usecase.dart';
import '../../domain/usecases/save_plan_usecase.dart';
import 'ai_planner_event.dart';
import 'ai_planner_state.dart';


class AIPlannerBloc extends Bloc<AIPlannerEvent, AIPlannerState> {
  final GenerateStudyPlanUseCase generateStudyPlanUseCase;
  final GetAIHistoryUseCase getAIHistoryUseCase;
  final GetWorkloadAnalysisUseCase getWorkloadAnalysisUseCase;
  final GetProductivityInsightsUseCase getProductivityInsightsUseCase;
  final GetRecommendationsUseCase getRecommendationsUseCase;
  final SavePlanUseCase savePlanUseCase;
  final DeletePlanUseCase deletePlanUseCase;
  final IAIPlannerRepository repository;

  AIPlannerBloc({
    required this.generateStudyPlanUseCase,
    required this.getAIHistoryUseCase,
    required this.getWorkloadAnalysisUseCase,
    required this.getProductivityInsightsUseCase,
    required this.getRecommendationsUseCase,
    required this.savePlanUseCase,
    required this.deletePlanUseCase,
    required this.repository,
  }) : super(const AIPlannerInitialState()) {
    on<GeneratePlanEvent>(_onGeneratePlan);
    on<LoadHistoryEvent>(_onLoadHistory);
    on<LoadInsightsEvent>(_onLoadInsights);
    on<LoadRecommendationsEvent>(_onLoadRecommendations);
    on<LoadDeadlineAnalysisEvent>(_onLoadDeadlineAnalysis);
    on<LoadWorkloadAnalysisEvent>(_onLoadWorkloadAnalysis);
    on<OptimizePrioritiesEvent>(_onOptimizePriorities);
    on<RefreshInsightsEvent>(_onRefreshInsights);
    on<SavePlanEvent>(_onSavePlan);
    on<DeletePlanEvent>(_onDeletePlan);
    on<ExportPlanEvent>(_onExportPlan);
  }

  AIPlannerLoadedState _getOrCreateLoadedState() {
    if (state is AIPlannerLoadedState) {
      return state as AIPlannerLoadedState;
    }
    return const AIPlannerLoadedState();
  }

  Future<void> _onGeneratePlan(
    GeneratePlanEvent event,
    Emitter<AIPlannerState> emit,
  ) async {
    emit(const AIPlannerLoadingState(loadingMessage: 'Generating AI Study Plan...'));
    final result = await generateStudyPlanUseCase(
      GenerateStudyPlanParams(
        timeframe: event.timeframe,
        targetSubjects: event.targetSubjects,
        dailyGoalMinutes: event.dailyGoalMinutes,
      ),
    );

    result.fold(
      (Failure failure) => emit(AIPlannerFailureState(message: failure.message, statusCode: failure.statusCode)),
      (plan) {
        final currentLoaded = _getOrCreateLoadedState();
        emit(currentLoaded.copyWith(currentStudyPlan: plan));
      },
    );
  }

  Future<void> _onLoadHistory(
    LoadHistoryEvent event,
    Emitter<AIPlannerState> emit,
  ) async {
    final result = await getAIHistoryUseCase(const NoParams());
    result.fold(
      (Failure failure) => emit(AIPlannerFailureState(message: failure.message, statusCode: failure.statusCode)),
      (historyItems) {
        final currentLoaded = _getOrCreateLoadedState();
        emit(currentLoaded.copyWith(historyItems: historyItems));
      },
    );
  }

  Future<void> _onLoadInsights(
    LoadInsightsEvent event,
    Emitter<AIPlannerState> emit,
  ) async {
    emit(const AIPlannerLoadingState(loadingMessage: 'Analyzing Productivity Insights...'));
    final result = await getProductivityInsightsUseCase(const NoParams());
    result.fold(
      (Failure failure) => emit(AIPlannerFailureState(message: failure.message, statusCode: failure.statusCode)),
      (insights) {
        final currentLoaded = _getOrCreateLoadedState();
        emit(currentLoaded.copyWith(productivityInsight: insights));
      },
    );
  }

  Future<void> _onLoadRecommendations(
    LoadRecommendationsEvent event,
    Emitter<AIPlannerState> emit,
  ) async {
    final result = await getRecommendationsUseCase(const NoParams());
    result.fold(
      (Failure failure) => emit(AIPlannerFailureState(message: failure.message, statusCode: failure.statusCode)),
      (recs) {
        final currentLoaded = _getOrCreateLoadedState();
        emit(currentLoaded.copyWith(recommendations: recs));
      },
    );
  }

  Future<void> _onLoadDeadlineAnalysis(
    LoadDeadlineAnalysisEvent event,
    Emitter<AIPlannerState> emit,
  ) async {
    emit(const AIPlannerLoadingState(loadingMessage: 'Evaluating Deadline Risks...'));
    final result = await repository.getDeadlineRiskAnalysis();
    result.fold(
      (Failure failure) => emit(AIPlannerFailureState(message: failure.message, statusCode: failure.statusCode)),
      (risk) {
        final currentLoaded = _getOrCreateLoadedState();
        emit(currentLoaded.copyWith(deadlineRisk: risk));
      },
    );
  }

  Future<void> _onLoadWorkloadAnalysis(
    LoadWorkloadAnalysisEvent event,
    Emitter<AIPlannerState> emit,
  ) async {
    emit(const AIPlannerLoadingState(loadingMessage: 'Analyzing Academic Workload...'));
    final result = await getWorkloadAnalysisUseCase(const NoParams());
    result.fold(
      (Failure failure) => emit(AIPlannerFailureState(message: failure.message, statusCode: failure.statusCode)),
      (workload) {
        final currentLoaded = _getOrCreateLoadedState();
        emit(currentLoaded.copyWith(workloadAnalysis: workload));
      },
    );
  }

  Future<void> _onOptimizePriorities(
    OptimizePrioritiesEvent event,
    Emitter<AIPlannerState> emit,
  ) async {
    emit(const AIPlannerLoadingState(loadingMessage: 'Optimizing Task Priorities...'));
    final result = await repository.prioritizeTasks(taskIds: event.taskIds);
    result.fold(
      (Failure failure) => emit(AIPlannerFailureState(message: failure.message, statusCode: failure.statusCode)),
      (optimizer) {
        final currentLoaded = _getOrCreateLoadedState();
        emit(currentLoaded.copyWith(priorityOptimizer: optimizer));
      },
    );
  }

  Future<void> _onRefreshInsights(
    RefreshInsightsEvent event,
    Emitter<AIPlannerState> emit,
  ) async {
    emit(const AIPlannerRefreshingState());
    final result = await getProductivityInsightsUseCase(const NoParams());
    result.fold(
      (Failure failure) => emit(AIPlannerFailureState(message: failure.message)),
      (insights) {
        final currentLoaded = _getOrCreateLoadedState();
        emit(currentLoaded.copyWith(productivityInsight: insights));
      },
    );
  }

  Future<void> _onSavePlan(
    SavePlanEvent event,
    Emitter<AIPlannerState> emit,
  ) async {
    final result = await savePlanUseCase(event.plan);
    result.fold(
      (Failure failure) => emit(AIPlannerFailureState(message: failure.message)),
      (savedPlan) {
        final currentLoaded = _getOrCreateLoadedState();
        final updatedSaved = List<dynamic>.from(currentLoaded.savedPlans)..add(savedPlan);
        emit(currentLoaded.copyWith(
          savedPlans: updatedSaved.cast(),
          currentStudyPlan: savedPlan,
        ));
      },
    );
  }

  Future<void> _onDeletePlan(
    DeletePlanEvent event,
    Emitter<AIPlannerState> emit,
  ) async {
    final result = await deletePlanUseCase(event.planId);
    result.fold(
      (Failure failure) => emit(AIPlannerFailureState(message: failure.message)),
      (_) {
        final currentLoaded = _getOrCreateLoadedState();
        final updatedSaved = currentLoaded.savedPlans.where((p) => p.id != event.planId).toList();
        emit(currentLoaded.copyWith(savedPlans: updatedSaved));
      },
    );
  }


  Future<void> _onExportPlan(
    ExportPlanEvent event,
    Emitter<AIPlannerState> emit,
  ) async {
    final currentLoaded = _getOrCreateLoadedState();
    emit(currentLoaded.copyWith(
      exportMessage: 'Successfully exported plan "${event.plan.title}" as ${event.format.toUpperCase()}.',
    ));
  }
}
