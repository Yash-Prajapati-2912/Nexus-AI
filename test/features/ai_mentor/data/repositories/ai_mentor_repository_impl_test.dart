import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/ai_mentor/data/datasources/ai_mentor_remote_data_source.dart';
import 'package:nexus_ai/features/ai_mentor/data/models/student_wellness_model.dart';
import 'package:nexus_ai/features/ai_mentor/data/repositories/ai_mentor_repository_impl.dart';

class MockAIMentorRemoteDataSource extends Mock implements IAIMentorRemoteDataSource {}

void main() {
  late AIMentorRepositoryImpl repository;
  late MockAIMentorRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAIMentorRemoteDataSource();
    repository = AIMentorRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tModel = StudentWellnessModel(
    overallWellnessScore: 86,
    academicPerformanceScore: 82,
    financialWellnessScore: 84,
    productivityScore: 88,
    careerReadinessScore: 78,
    goalProgressScore: 85,
    habitConsistencyScore: 89,
    wellnessLevel: 'BALANCED',
    keyRecommendations: ['Study well'],
  );

  test('should return StudentWellness when remote data source is successful', () async {
    when(() => mockRemoteDataSource.getWellnessScores()).thenAnswer((_) async => tModel);

    final result = await repository.getWellnessScores();

    expect(result, const Right(tModel));
    verify(() => mockRemoteDataSource.getWellnessScores()).called(1);
  });
}
