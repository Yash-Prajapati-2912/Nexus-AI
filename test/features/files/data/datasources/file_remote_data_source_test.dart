import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/core/network/api_client.dart';
import 'package:nexus_ai/features/files/data/datasources/file_remote_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late FileRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = FileRemoteDataSourceImpl(mockApiClient);
  });

  test('getFiles should call GET /media and return FileModel list', () async {
    when(() => mockApiClient.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/media'),
        statusCode: 200,
        data: [
          {
            'id': 'fl1',
            'ownerId': 'u1',
            'fileName': 'CS101_Lecture_Notes.pdf',
            'originalName': 'CS101.pdf',
            'mimeType': 'application/pdf',
            'extension': 'pdf',
            'sizeBytes': 2450000,
            'folder': 'Documents',
            'moduleName': 'PLANNER',
            'fileUrl': 'https://api.nexus-ai.com/files/cs101.pdf',
            'createdAt': DateTime.now().toIso8601String(),
          }
        ],
      ),
    );

    final result = await dataSource.getFiles();

    expect(result.length, equals(1));
    expect(result.first.fileName, equals('CS101_Lecture_Notes.pdf'));
  });
}
