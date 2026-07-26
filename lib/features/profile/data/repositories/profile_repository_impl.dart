import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/exceptions.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:nexus_ai/features/profile/domain/entities/academic_profile.dart';
import 'package:nexus_ai/features/profile/domain/entities/achievement.dart';
import 'package:nexus_ai/features/profile/domain/entities/connected_account.dart';
import 'package:nexus_ai/features/profile/domain/entities/security_settings.dart';
import 'package:nexus_ai/features/profile/domain/entities/user_preferences.dart';
import 'package:nexus_ai/features/profile/domain/entities/user_profile.dart';
import 'package:nexus_ai/features/profile/domain/entities/user_statistics.dart';
import 'package:nexus_ai/features/profile/domain/repositories/i_profile_repository.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final profile = await remoteDataSource.getProfile();
      return Right(profile);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(Map<String, dynamic> body) async {
    try {
      final profile = await remoteDataSource.updateProfile(body);
      return Right(profile);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAvatar(String imagePath) async {
    try {
      final url = await remoteDataSource.uploadAvatar(imagePath);
      return Right(url);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AcademicProfile>> getAcademicProfile() async {
    try {
      final acad = await remoteDataSource.getAcademicProfile();
      return Right(acad);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AcademicProfile>> updateAcademicProfile(Map<String, dynamic> body) async {
    try {
      final acad = await remoteDataSource.updateAcademicProfile(body);
      return Right(acad);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserPreferences>> getPreferences() async {
    try {
      final prefs = await remoteDataSource.getPreferences();
      return Right(prefs);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserPreferences>> updatePreferences(Map<String, dynamic> body) async {
    try {
      final prefs = await remoteDataSource.updatePreferences(body);
      return Right(prefs);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserStatistics>> getStatistics() async {
    try {
      final stats = await remoteDataSource.getStatistics();
      return Right(stats);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Achievement>>> getAchievements() async {
    try {
      final list = await remoteDataSource.getAchievements();
      return Right(list);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ConnectedAccount>>> getConnectedAccounts() async {
    try {
      final list = await remoteDataSource.getConnectedAccounts();
      return Right(list);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> linkConnectedAccount(String provider) async {
    try {
      await remoteDataSource.linkConnectedAccount(provider);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> unlinkConnectedAccount(String provider) async {
    try {
      await remoteDataSource.unlinkConnectedAccount(provider);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SecuritySettings>> getSecuritySettings() async {
    try {
      final sec = await remoteDataSource.getSecuritySettings();
      return Right(sec);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword(String currentPassword, String newPassword) async {
    try {
      await remoteDataSource.changePassword(currentPassword, newPassword);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> exportUserData() async {
    try {
      final url = await remoteDataSource.exportUserData();
      return Right(url);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(Object e) {
    if (e is ValidationException) {
      return ValidationFailure(message: e.message, fieldErrors: e.errors);
    } else if (e is UnauthorizedException) {
      return const UnauthorizedFailure();
    } else if (e is ServerException) {
      return ServerFailure(message: e.message, statusCode: e.statusCode);
    } else if (e is NetworkException) {
      return NetworkFailure(message: e.message);
    } else {
      return UnknownFailure(message: e.toString());
    }
  }
}
