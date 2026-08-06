import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../../domain/entities/academic_profile.dart';
import '../../domain/entities/user_preferences.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_academic_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_avatar_usecase.dart';

// EVENTS
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  const LoadProfileEvent();
}

class UpdateUserProfileEvent extends ProfileEvent {
  final Map<String, dynamic> body;
  const UpdateUserProfileEvent(this.body);
  @override
  List<Object?> get props => [body];
}

class UploadAvatarEvent extends ProfileEvent {
  final String imagePath;
  const UploadAvatarEvent(this.imagePath);
  @override
  List<Object?> get props => [imagePath];
}

class UpdateAcademicEvent extends ProfileEvent {
  final Map<String, dynamic> body;
  const UpdateAcademicEvent(this.body);
  @override
  List<Object?> get props => [body];
}

class UpdatePreferencesEvent extends ProfileEvent {
  final Map<String, dynamic> body;
  const UpdatePreferencesEvent(this.body);
  @override
  List<Object?> get props => [body];
}

// STATES
abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitialState extends ProfileState {
  const ProfileInitialState();
}

class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState();
}

class ProfileFailureState extends ProfileState {
  final String message;
  const ProfileFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class ProfileLoadedState extends ProfileState {
  final UserProfile profile;
  final AcademicProfile academic;
  final UserPreferences preferences;

  const ProfileLoadedState({
    required this.profile,
    required this.academic,
    required this.preferences,
  });

  ProfileLoadedState copyWith({
    UserProfile? profile,
    AcademicProfile? academic,
    UserPreferences? preferences,
  }) {
    return ProfileLoadedState(
      profile: profile ?? this.profile,
      academic: academic ?? this.academic,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [profile, academic, preferences];
}

// BLOC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UploadAvatarUseCase uploadAvatarUseCase;
  final UpdateAcademicProfileUseCase updateAcademicProfileUseCase;
  final IProfileRepository repository;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.uploadAvatarUseCase,
    required this.updateAcademicProfileUseCase,
    required this.repository,
  }) : super(const ProfileInitialState()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateUserProfileEvent>(_onUpdateProfile);
    on<UploadAvatarEvent>(_onUploadAvatar);
    on<UpdateAcademicEvent>(_onUpdateAcademic);
    on<UpdatePreferencesEvent>(_onUpdatePreferences);
  }

  Future<void> _onLoadProfile(LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoadingState());
    try {
      final profileRes = await getProfileUseCase(const NoParams());
      final acadRes = await repository.getAcademicProfile();
      final prefRes = await repository.getPreferences();

      final profile = profileRes.getOrElse(
        (_) => const UserProfile(
          id: '',
          userId: '',
          displayName: '',
          username: '',
          email: '',
          bio: null,
          timezone: 'UTC',
          language: 'en',
          completionPercentage: 0,
        ),
      );

      final acad = acadRes.getOrElse((_) => const AcademicProfile(
            id: '',
            university: '',
            college: '',
            degree: '',
            branch: '',
            semester: 0,
            currentYear: 0,
            cgpa: 0.0,
            graduationYear: 0,
            subjects: [],
            skills: [],
            careerInterests: [],
          ));

      final pref = prefRes.getOrElse((_) => const UserPreferences(
            learningStyle: 'VISUAL',
            preferredStudyTime: 'EVENING',
            communicationStyle: 'CONCISE',
            productivityGoals: '',
            financialGoals: '',
            careerGoals: '',
            aiTone: 'ENCOURAGEMENT',
            profileVisibility: 'PUBLIC',
          ));

      emit(ProfileLoadedState(profile: profile, academic: acad, preferences: pref));
    } catch (e) {
      emit(ProfileFailureState(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(UpdateUserProfileEvent event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoadedState) {
      final currentState = state as ProfileLoadedState;
      final res = await updateProfileUseCase(event.body);
      res.fold(
        (Failure f) => emit(ProfileFailureState(f.message)),
        (updated) => emit(currentState.copyWith(profile: updated)),
      );
    }
  }

  Future<void> _onUploadAvatar(UploadAvatarEvent event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoadedState) {
      final currentState = state as ProfileLoadedState;
      final res = await uploadAvatarUseCase(event.imagePath);
      res.fold(
        (Failure f) => emit(ProfileFailureState(f.message)),
        (newUrl) {
          final updated = UserProfile(
            id: currentState.profile.id,
            userId: currentState.profile.userId,
            displayName: currentState.profile.displayName,
            username: currentState.profile.username,
            email: currentState.profile.email,
            phone: currentState.profile.phone,
            avatarUrl: newUrl,
            coverImageUrl: currentState.profile.coverImageUrl,
            bio: currentState.profile.bio,
            dateOfBirth: currentState.profile.dateOfBirth,
            gender: currentState.profile.gender,
            country: currentState.profile.country,
            city: currentState.profile.city,
            timezone: currentState.profile.timezone,
            language: currentState.profile.language,
            completionPercentage: currentState.profile.completionPercentage,
          );
          emit(currentState.copyWith(profile: updated));
        },
      );
    }
  }

  Future<void> _onUpdateAcademic(UpdateAcademicEvent event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoadedState) {
      final currentState = state as ProfileLoadedState;
      final res = await updateAcademicProfileUseCase(event.body);
      res.fold(
        (Failure f) => emit(ProfileFailureState(f.message)),
        (updated) => emit(currentState.copyWith(academic: updated)),
      );
    }
  }

  Future<void> _onUpdatePreferences(UpdatePreferencesEvent event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoadedState) {
      final currentState = state as ProfileLoadedState;
      final res = await repository.updatePreferences(event.body);
      res.fold(
        (Failure f) => emit(ProfileFailureState(f.message)),
        (updated) => emit(currentState.copyWith(preferences: updated)),
      );
    }
  }
}
