import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/core/network/api_client.dart';
import 'package:nexus_ai/features/profile/data/datasources/profile_remote_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late ProfileRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = ProfileRemoteDataSourceImpl(mockApiClient);
  });

  test('getProfile should call GET /profile/me and parse UserProfileModel', () async {
    when(() => mockApiClient.get(any())).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/profile/me'),
        statusCode: 200,
        data: {
          'id': 'u1',
          'userId': 'usr1',
          'displayName': 'Alex Rivers',
          'username': 'alexrivers',
          'email': 'alex@stanford.edu',
          'timezone': 'PST',
          'language': 'en',
          'completionPercentage': 90,
        },
      ),
    );

    final result = await dataSource.getProfile();

    expect(result.displayName, equals('Alex Rivers'));
    expect(result.email, equals('alex@stanford.edu'));
  });
}
