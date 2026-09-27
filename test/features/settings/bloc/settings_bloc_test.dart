import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import 'package:nexus_ai/features/settings/domain/entities/settings_entity.dart';
import 'package:nexus_ai/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:nexus_ai/features/settings/domain/usecases/update_preferences_usecase.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/settings_event.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/settings_state.dart';

class MockGetSettingsUseCase extends Mock implements GetSettingsUseCase {}
class MockUpdatePreferencesUseCase extends Mock implements UpdatePreferencesUseCase {}

void main() {
  late SettingsBloc settingsBloc;
  late MockGetSettingsUseCase mockGetSettingsUseCase;
  late MockUpdatePreferencesUseCase mockUpdatePreferencesUseCase;
  late SettingsEntity tSettings;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockGetSettingsUseCase = MockGetSettingsUseCase();
    mockUpdatePreferencesUseCase = MockUpdatePreferencesUseCase();
    settingsBloc = SettingsBloc(
      getSettingsUseCase: mockGetSettingsUseCase,
      updatePreferencesUseCase: mockUpdatePreferencesUseCase,
    );
    tSettings = SettingsEntity.initial();
  });

  tearDown(() {
    settingsBloc.close();
  });

  test('initial state should be SettingsInitial', () {
    expect(settingsBloc.state, equals(SettingsInitial()));
  });

  blocTest<SettingsBloc, SettingsState>(
    'emits [SettingsLoading, SettingsLoaded] when LoadSettingsEvent succeeds',
    build: () {
      when(() => mockGetSettingsUseCase(any()))
          .thenAnswer((_) async => Right(tSettings));
      return settingsBloc;
    },
    act: (bloc) => bloc.add(LoadSettingsEvent()),
    expect: () => [
      SettingsLoading(),
      SettingsLoaded(tSettings),
    ],
  );

  blocTest<SettingsBloc, SettingsState>(
    'emits [SettingsLoading, SettingsError] when LoadSettingsEvent fails',
    build: () {
      when(() => mockGetSettingsUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Server Error')));
      return settingsBloc;
    },
    act: (bloc) => bloc.add(LoadSettingsEvent()),
    expect: () => [
      SettingsLoading(),
      const SettingsError('Server Error'),
    ],
  );
}
