import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/ai_planner/data/datasources/ai_planner_remote_data_source.dart';
import 'package:nexus_ai/features/ai_planner/data/models/study_plan_model.dart';
import 'package:nexus_ai/features/ai_planner/data/repositories/ai_planner_repository_impl.dart';
import 'package:nexus_ai/features/ai_planner/domain/entities/study_plan.dart';

class MockAIPlannerRemoteDataSource extends Mock implements IAIPlannerRemoteDataSource {}

void main() {
  late AIPlannerRepositoryImpl repository;
  late MockAIPlannerRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAIPlannerRemoteDataSource();
    repository = AIPlannerRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tStudyPlanModel = StudyPlanModel(
    id: 'plan-1',
    title: 'Test Model Plan',
    summary: 'Test Model Summary',
    timeframe: 'weekly',
    reasoning: const [],
    actionItems: const [],
    warnings: const [],
    confidenceScore: 0.92,
    providerName: 'GEMINI',
    createdAt: DateTime.now(),
  );

  test('generateStudyPlan returns Right(StudyPlan) when remote call is successful', () async {
    when(() => mockRemoteDataSource.generateStudyPlan(
          timeframe: 'weekly',
          targetSubjects: null,
          dailyGoalMinutes: null,
        )).thenAnswer((_) async => tStudyPlanModel);

    final result = await repository.generateStudyPlan(timeframe: 'weekly');

    expect(result.isRight(), isTrue);
    result.fold(
      (failure) => fail('Should not return failure'),
      (StudyPlan plan) => expect(plan.title, equals('Test Model Plan')),
    );
  });
}
