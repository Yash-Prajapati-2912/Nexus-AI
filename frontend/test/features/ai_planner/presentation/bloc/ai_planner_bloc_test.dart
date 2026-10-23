import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/ai_planner/domain/entities/study_plan.dart';
import 'package:nexus_ai/features/ai_planner/domain/repositories/i_ai_planner_repository.dart';

import 'package:nexus_ai/features/ai_planner/domain/usecases/delete_plan_usecase.dart';
import 'package:nexus_ai/features/ai_planner/domain/usecases/generate_study_plan_usecase.dart';
import 'package:nexus_ai/features/ai_planner/domain/usecases/get_ai_history_usecase.dart';
import 'package:nexus_ai/features/ai_planner/domain/usecases/get_productivity_insights_usecase.dart';
import 'package:nexus_ai/features/ai_planner/domain/usecases/get_recommendations_usecase.dart';
import 'package:nexus_ai/features/ai_planner/domain/usecases/get_workload_analysis_usecase.dart';
import 'package:nexus_ai/features/ai_planner/domain/usecases/save_plan_usecase.dart';
import 'package:nexus_ai/features/ai_planner/presentation/bloc/ai_planner_bloc.dart';
import 'package:nexus_ai/features/ai_planner/presentation/bloc/ai_planner_event.dart';
import 'package:nexus_ai/features/ai_planner/presentation/bloc/ai_planner_state.dart';

class MockGenerateStudyPlanUseCase extends Mock implements GenerateStudyPlanUseCase {}
class MockGetAIHistoryUseCase extends Mock implements GetAIHistoryUseCase {}
class MockGetWorkloadAnalysisUseCase extends Mock implements GetWorkloadAnalysisUseCase {}
class MockGetProductivityInsightsUseCase extends Mock implements GetProductivityInsightsUseCase {}
class MockGetRecommendationsUseCase extends Mock implements GetRecommendationsUseCase {}
class MockSavePlanUseCase extends Mock implements SavePlanUseCase {}
class MockDeletePlanUseCase extends Mock implements DeletePlanUseCase {}
class MockAIPlannerRepository extends Mock implements IAIPlannerRepository {}

void main() {
  late AIPlannerBloc bloc;
  late MockGenerateStudyPlanUseCase mockGenerateStudyPlanUseCase;
  late MockGetAIHistoryUseCase mockGetAIHistoryUseCase;
  late MockGetWorkloadAnalysisUseCase mockGetWorkloadAnalysisUseCase;
  late MockGetProductivityInsightsUseCase mockGetProductivityInsightsUseCase;
  late MockGetRecommendationsUseCase mockGetRecommendationsUseCase;
  late MockSavePlanUseCase mockSavePlanUseCase;
  late MockDeletePlanUseCase mockDeletePlanUseCase;
  late MockAIPlannerRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const GenerateStudyPlanParams(timeframe: 'weekly'));
  });

  setUp(() {
    mockGenerateStudyPlanUseCase = MockGenerateStudyPlanUseCase();
    mockGetAIHistoryUseCase = MockGetAIHistoryUseCase();
    mockGetWorkloadAnalysisUseCase = MockGetWorkloadAnalysisUseCase();
    mockGetProductivityInsightsUseCase = MockGetProductivityInsightsUseCase();
    mockGetRecommendationsUseCase = MockGetRecommendationsUseCase();
    mockSavePlanUseCase = MockSavePlanUseCase();
    mockDeletePlanUseCase = MockDeletePlanUseCase();
    mockRepository = MockAIPlannerRepository();

    bloc = AIPlannerBloc(
      generateStudyPlanUseCase: mockGenerateStudyPlanUseCase,
      getAIHistoryUseCase: mockGetAIHistoryUseCase,
      getWorkloadAnalysisUseCase: mockGetWorkloadAnalysisUseCase,
      getProductivityInsightsUseCase: mockGetProductivityInsightsUseCase,
      getRecommendationsUseCase: mockGetRecommendationsUseCase,
      savePlanUseCase: mockSavePlanUseCase,
      deletePlanUseCase: mockDeletePlanUseCase,
      repository: mockRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  final tStudyPlan = StudyPlan(
    id: 'plan-1',
    title: 'Test Plan',
    summary: 'Test summary',
    timeframe: 'weekly',
    reasoning: const ['Reason 1'],
    actionItems: const [],
    warnings: const [],
    confidenceScore: 0.95,
    providerName: 'GEMINI',
    createdAt: DateTime.now(),
  );

  test('initial state is AIPlannerInitialState', () {
    expect(bloc.state, equals(const AIPlannerInitialState()));
  });

  blocTest<AIPlannerBloc, AIPlannerState>(
    'emits [AIPlannerLoadingState, AIPlannerLoadedState] when GeneratePlanEvent succeeds',
    build: () {
      when(() => mockGenerateStudyPlanUseCase(any()))
          .thenAnswer((_) async => Right(tStudyPlan));
      return bloc;
    },
    act: (b) => b.add(const GeneratePlanEvent(timeframe: 'weekly')),
    expect: () => [
      const AIPlannerLoadingState(loadingMessage: 'Generating AI Study Plan...'),
      isA<AIPlannerLoadedState>().having((s) => s.currentStudyPlan, 'currentStudyPlan', tStudyPlan),
    ],
  );
}
