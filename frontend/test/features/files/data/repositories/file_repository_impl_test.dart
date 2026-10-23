import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/files/data/datasources/file_remote_data_source.dart';
import 'package:nexus_ai/features/files/data/models/file_model.dart';
import 'package:nexus_ai/features/files/data/repositories/file_repository_impl.dart';

class MockFileRemoteDataSource extends Mock implements IFileRemoteDataSource {}

void main() {
  late FileRepositoryImpl repository;
  late MockFileRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockFileRemoteDataSource();
    repository = FileRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tModel = FileModel(
    id: 'fl1',
    ownerId: 'u1',
    fileName: 'CS101_Lecture_Notes.pdf',
    originalName: 'CS101.pdf',
    mimeType: 'application/pdf',
    extension: 'pdf',
    sizeBytes: 2450000,
    folder: 'Documents',
    moduleName: 'PLANNER',
    fileUrl: 'https://api.nexus-ai.com/files/cs101.pdf',
    createdAt: DateTime.now(),
  );

  test('getFiles should return list of FileItem when remote data source is successful', () async {
    when(() => mockRemoteDataSource.getFiles(page: 1, limit: 20)).thenAnswer((_) async => [tModel]);

    final result = await repository.getFiles();

    expect(result.isRight(), isTrue);
    result.fold(
      (l) => fail('Should be right'),
      (list) => expect(list.first.id, equals(tModel.id)),
    );
    verify(() => mockRemoteDataSource.getFiles(page: 1, limit: 20)).called(1);
  });
}
