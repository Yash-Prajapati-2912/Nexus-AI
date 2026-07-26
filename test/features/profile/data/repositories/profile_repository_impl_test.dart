import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:nexus_ai/features/profile/data/models/user_profile_model.dart';
import 'package:nexus_ai/features/profile/data/repositories/profile_repository_impl.dart';

class MockProfileRemoteDataSource extends Mock implements IProfileRemoteDataSource {}

void main() {
  late ProfileRepositoryImpl repository;
  late MockProfileRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    repository = ProfileRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tModel = UserProfileModel(
    id: 'u1',
    userId: 'usr1',
    displayName: 'Alex Rivers',
    username: 'alexrivers',
    email: 'alex@stanford.edu',
    timezone: 'PST',
    language: 'en',
    completionPercentage: 90,
  );

  test('getProfile should return UserProfile when remote data source is successful', () async {
    when(() => mockRemoteDataSource.getProfile()).thenAnswer((_) async => tModel);

    final result = await repository.getProfile();

    expect(result, const Right(tModel));
    verify(() => mockRemoteDataSource.getProfile()).called(1);
  });
}
