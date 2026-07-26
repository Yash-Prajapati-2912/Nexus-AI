import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:nexus_ai/core/network/api_client.dart';
import 'package:nexus_ai/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:nexus_ai/features/settings/data/models/settings_model.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late SettingsRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = SettingsRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  test('getSettings performs GET /settings and returns SettingsModel', () async {
    final responseData = {
      'id': 'test-1',
      'userId': 'user-1',
      'theme': {'theme': 'DARK'},
    };
    when(() => mockApiClient.get('/settings')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/settings'),
        data: responseData,
        statusCode: 200,
      ),
    );

    final result = await dataSource.getSettings();

    expect(result, isA<SettingsModel>());
    expect(result.id, equals('test-1'));
    verify(() => mockApiClient.get('/settings')).called(1);
  });
}
