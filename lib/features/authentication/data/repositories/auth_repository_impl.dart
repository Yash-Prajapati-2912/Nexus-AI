import 'package:fpdart/fpdart.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/session_manager.dart';
import '../../domain/entities/auth_tokens_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/dtos/forgot_password_request_dto.dart';
import '../models/dtos/login_request_dto.dart';
import '../models/dtos/register_request_dto.dart';
import '../models/dtos/reset_password_request_dto.dart';
import '../models/dtos/verify_email_request_dto.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;
  final SessionManager _sessionManager;

  AuthRepositoryImpl({
    required IAuthRemoteDataSource remoteDataSource,
    required SessionManager sessionManager,
  })  : _remoteDataSource = remoteDataSource,
        _sessionManager = sessionManager;

  @override
  Future<Either<Failure, AuthTokensEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final tokensModel = await _remoteDataSource.login(
        LoginRequestDto(email: email, password: password),
      );
      await _sessionManager.saveSession(
        accessToken: tokensModel.accessToken,
        refreshToken: tokensModel.refreshToken,
      );
      return Right(tokensModel.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final userModel = await _remoteDataSource.register(
        RegisterRequestDto(email: email, password: password, fullName: fullName),
      );
      return Right(userModel.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _sessionManager.clearSession();
      return const Right(null);
    } catch (e) {
      await _sessionManager.clearSession();
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> logoutAll() async {
    try {
      await _remoteDataSource.logoutAll();
      await _sessionManager.clearSession();
      return const Right(null);
    } catch (e) {
      await _sessionManager.clearSession();
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, AuthTokensEntity>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final tokensModel = await _remoteDataSource.refreshToken(refreshToken);
      await _sessionManager.saveSession(
        accessToken: tokensModel.accessToken,
        refreshToken: tokensModel.refreshToken,
      );
      return Right(tokensModel.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  }) async {
    try {
      await _remoteDataSource.forgotPassword(ForgotPasswordRequestDto(email: email));
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        ResetPasswordRequestDto(token: token, newPassword: newPassword),
      );
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail({
    required String token,
  }) async {
    try {
      await _remoteDataSource.verifyEmail(VerifyEmailRequestDto(token: token));
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> resendVerification({
    required String email,
  }) async {
    try {
      await _remoteDataSource.resendVerification(email);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      return Right(userModel.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
