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

  test('uploadAvatar sends multipart/form-data with file field to /profile/avatar', () async {
    when(() => mockApiClient.post('/profile/avatar', data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/profile/avatar'),
        statusCode: 200,
        data: {
          'avatarUrl': 'https://cdn.nexus-ai.com/avatars/user_123.png',
        },
      ),
    );

    final result = await dataSource.uploadAvatar(
      'avatar.png',
      bytes: [1, 2, 3, 4],
      filename: 'avatar.png',
    );

    expect(result, equals('https://cdn.nexus-ai.com/avatars/user_123.png'));
    final captured = verify(() => mockApiClient.post('/profile/avatar', data: captureAny(named: 'data'))).captured;
    expect(captured.first, isA<FormData>());
    final formData = captured.first as FormData;
    expect(formData.files.any((f) => f.key == 'file'), isTrue);
  });

  test('changePassword sends POST to /auth/change-password with current and new password', () async {
    when(() => mockApiClient.post(
          '/auth/change-password',
          data: any(named: 'data'),
        )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/auth/change-password'),
        statusCode: 200,
        data: {'success': true, 'message': 'Password changed successfully.'},
      ),
    );

    await dataSource.changePassword('OldPassword123!', 'NewPassword123!');

    verify(() => mockApiClient.post(
          '/auth/change-password',
          data: {
            'currentPassword': 'OldPassword123!',
            'newPassword': 'NewPassword123!',
          },
        )).called(1);
  });
}
