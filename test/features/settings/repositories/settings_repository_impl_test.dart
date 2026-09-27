import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:nexus_ai/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:nexus_ai/features/settings/data/models/settings_model.dart';
import 'package:nexus_ai/features/settings/data/repositories/settings_repository_impl.dart';

class MockSettingsRemoteDataSource extends Mock implements ISettingsRemoteDataSource {}
class MockSettingsLocalDataSource extends Mock implements ISettingsLocalDataSource {}

void main() {
  late SettingsRepositoryImpl repository;
  late MockSettingsRemoteDataSource mockRemoteDataSource;
  late MockSettingsLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockSettingsRemoteDataSource();
    mockLocalDataSource = MockSettingsLocalDataSource();
    repository = SettingsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  test('getSettings returns remote settings and caches them locally', () async {
    final tModel = SettingsModel.fromJson(const {});
    when(() => mockLocalDataSource.getCachedSettings()).thenAnswer((_) async => null);
    when(() => mockRemoteDataSource.getSettings()).thenAnswer((_) async => tModel);
    when(() => mockLocalDataSource.cacheSettings(tModel)).thenAnswer((_) async {});

    final result = await repository.getSettings();

    expect(result.isRight(), isTrue);
    verify(() => mockRemoteDataSource.getSettings()).called(1);
    verify(() => mockLocalDataSource.cacheSettings(tModel)).called(1);
  });
}
