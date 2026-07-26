import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import 'package:nexus_ai/features/profile/domain/entities/academic_profile.dart';
import 'package:nexus_ai/features/profile/domain/entities/user_preferences.dart';
import 'package:nexus_ai/features/profile/domain/entities/user_profile.dart';
import 'package:nexus_ai/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:nexus_ai/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:nexus_ai/features/profile/domain/usecases/update_academic_profile_usecase.dart';
import 'package:nexus_ai/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:nexus_ai/features/profile/domain/usecases/upload_avatar_usecase.dart';
import 'package:nexus_ai/features/profile/presentation/bloc/profile_bloc.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}
class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}
class MockUploadAvatarUseCase extends Mock implements UploadAvatarUseCase {}
class MockUpdateAcademicProfileUseCase extends Mock implements UpdateAcademicProfileUseCase {}
class MockProfileRepository extends Mock implements IProfileRepository {}

void main() {
  late ProfileBloc bloc;
  late MockGetProfileUseCase mockGetProfileUseCase;
  late MockUpdateProfileUseCase mockUpdateProfileUseCase;
  late MockUploadAvatarUseCase mockUploadAvatarUseCase;
  late MockUpdateAcademicProfileUseCase mockUpdateAcademicProfileUseCase;
  late MockProfileRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockGetProfileUseCase = MockGetProfileUseCase();
    mockUpdateProfileUseCase = MockUpdateProfileUseCase();
    mockUploadAvatarUseCase = MockUploadAvatarUseCase();
    mockUpdateAcademicProfileUseCase = MockUpdateAcademicProfileUseCase();
    mockRepository = MockProfileRepository();

    bloc = ProfileBloc(
      getProfileUseCase: mockGetProfileUseCase,
      updateProfileUseCase: mockUpdateProfileUseCase,
      uploadAvatarUseCase: mockUploadAvatarUseCase,
      updateAcademicProfileUseCase: mockUpdateAcademicProfileUseCase,
      repository: mockRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  const tProfile = UserProfile(
    id: 'u1',
    userId: 'usr1',
    displayName: 'Alex Rivers',
    username: 'alexrivers',
    email: 'alex@stanford.edu',
    timezone: 'PST',
    language: 'en',
    completionPercentage: 90,
  );

  const tAcademic = AcademicProfile(
    id: 'a1',
    university: 'Stanford',
    college: 'Engineering',
    degree: 'B.S.',
    branch: 'CS',
    semester: 6,
    currentYear: 3,
    cgpa: 3.85,
    graduationYear: 2027,
    subjects: ['CS101'],
    skills: ['Flutter'],
    careerInterests: ['AI'],
  );

  const tPref = UserPreferences(
    learningStyle: 'VISUAL',
    preferredStudyTime: 'EVENING',
    communicationStyle: 'CONCISE',
    productivityGoals: '4 sessions',
    financialGoals: 'Save \$150',
    careerGoals: 'AI Architect',
    aiTone: 'ENCOURAGEMENT',
    profileVisibility: 'PUBLIC',
  );

  test('initial state should be ProfileInitialState', () {
    expect(bloc.state, equals(const ProfileInitialState()));
  });

  blocTest<ProfileBloc, ProfileState>(
    'emits [ProfileLoadingState, ProfileLoadedState] when LoadProfileEvent is added',
    build: () {
      when(() => mockGetProfileUseCase(any())).thenAnswer((_) async => const Right(tProfile));
      when(() => mockRepository.getAcademicProfile()).thenAnswer((_) async => const Right(tAcademic));
      when(() => mockRepository.getPreferences()).thenAnswer((_) async => const Right(tPref));
      return bloc;
    },
    act: (b) => b.add(const LoadProfileEvent()),
    expect: () => [
      const ProfileLoadingState(),
      const ProfileLoadedState(profile: tProfile, academic: tAcademic, preferences: tPref),
    ],
  );
}
