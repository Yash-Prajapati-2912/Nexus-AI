import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../entities/academic_profile.dart';
import '../entities/achievement.dart';
import '../entities/connected_account.dart';
import '../entities/security_settings.dart';
import '../entities/user_preferences.dart';
import '../entities/user_profile.dart';
import '../entities/user_statistics.dart';

abstract class IProfileRepository {
  Future<Either<Failure, UserProfile>> getProfile();
  Future<Either<Failure, UserProfile>> updateProfile(Map<String, dynamic> body);
  Future<Either<Failure, String>> uploadAvatar(String imagePath);
  Future<Either<Failure, AcademicProfile>> getAcademicProfile();
  Future<Either<Failure, AcademicProfile>> updateAcademicProfile(Map<String, dynamic> body);
  Future<Either<Failure, UserPreferences>> getPreferences();
  Future<Either<Failure, UserPreferences>> updatePreferences(Map<String, dynamic> body);
  Future<Either<Failure, UserStatistics>> getStatistics();
  Future<Either<Failure, List<Achievement>>> getAchievements();
  Future<Either<Failure, List<ConnectedAccount>>> getConnectedAccounts();
  Future<Either<Failure, Unit>> linkConnectedAccount(String provider);
  Future<Either<Failure, Unit>> unlinkConnectedAccount(String provider);
  Future<Either<Failure, SecuritySettings>> getSecuritySettings();
  Future<Either<Failure, Unit>> changePassword(String currentPassword, String newPassword);
  Future<Either<Failure, String>> exportUserData();
  Future<Either<Failure, Unit>> deleteAccount();
}
