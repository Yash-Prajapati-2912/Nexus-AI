import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/core/error/exceptions.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/features/ai_mentor/data/datasources/ai_mentor_remote_data_source.dart';
import 'package:nexus_ai/features/ai_mentor/data/models/conversation_model.dart';
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

  final tConvModel = ConversationModel(
    id: 'conv-123',
    title: 'Updated Title',
    createdAt: DateTime(2026, 10, 20),
    updatedAt: DateTime(2026, 10, 21),
    messageCount: 5,
    lastMessageSnippet: 'Last message snippet',
    topic: 'GENERAL',
    isPinned: true,
    isArchived: false,
  );

  test('should return StudentWellness when remote data source is successful', () async {
    when(() => mockRemoteDataSource.getWellnessScores()).thenAnswer((_) async => tModel);

    final result = await repository.getWellnessScores();

    expect(result, const Right(tModel));
    verify(() => mockRemoteDataSource.getWellnessScores()).called(1);
  });

  test('updateConversation returns updated Conversation on remote success', () async {
    when(() => mockRemoteDataSource.updateConversation('conv-123', title: 'Updated Title', isPinned: true, isArchived: false))
        .thenAnswer((_) async => tConvModel);

    final result = await repository.updateConversation('conv-123', title: 'Updated Title', isPinned: true, isArchived: false);

    expect(result, Right(tConvModel));
    verify(() => mockRemoteDataSource.updateConversation('conv-123', title: 'Updated Title', isPinned: true, isArchived: false)).called(1);
  });

  test('updateConversation returns ServerFailure when remote throws ServerException', () async {
    when(() => mockRemoteDataSource.updateConversation('conv-123', title: 'Updated Title', isPinned: null, isArchived: null))
        .thenThrow(const ServerException(message: 'Forbidden'));

    final result = await repository.updateConversation('conv-123', title: 'Updated Title');

    expect(result.isLeft(), isTrue);
    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (_) => fail('Should be Left'),
    );
  });

  test('deleteConversation returns Right(unit) on success', () async {
    when(() => mockRemoteDataSource.deleteConversation('conv-123')).thenAnswer((_) async {});

    final result = await repository.deleteConversation('conv-123');

    expect(result, const Right(unit));
    verify(() => mockRemoteDataSource.deleteConversation('conv-123')).called(1);
  });

  test('deleteConversation returns ServerFailure on ServerException', () async {
    when(() => mockRemoteDataSource.deleteConversation('conv-123')).thenThrow(const ServerException(message: 'Not found'));

    final result = await repository.deleteConversation('conv-123');

    expect(result.isLeft(), isTrue);
    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (_) => fail('Should be Left'),
    );
  });
}

