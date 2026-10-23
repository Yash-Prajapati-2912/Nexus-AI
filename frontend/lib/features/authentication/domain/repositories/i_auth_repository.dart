import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_tokens_entity.dart';
import '../entities/user_entity.dart';

/// Abstract Domain Contract for Authentication Operations.
abstract class IAuthRepository {
  Future<Either<Failure, AuthTokensEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> logoutAll();

  Future<Either<Failure, AuthTokensEntity>> refreshToken({
    required String refreshToken,
  });

  Future<Either<Failure, void>> forgotPassword({
    required String email,
  });

  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<Either<Failure, void>> verifyEmail({
    required String token,
  });

  Future<Either<Failure, void>> resendVerification({
    required String email,
  });

  Future<Either<Failure, UserEntity>> getCurrentUser();
}
