import '../../../../config/constants/api_constants.dart';
import '../../../../core/network/base_remote_data_source.dart';
import '../models/auth_tokens_model.dart';
import '../models/dtos/forgot_password_request_dto.dart';
import '../models/dtos/login_request_dto.dart';
import '../models/dtos/register_request_dto.dart';
import '../models/dtos/reset_password_request_dto.dart';
import '../models/dtos/verify_email_request_dto.dart';
import '../models/user_model.dart';

abstract class IAuthRemoteDataSource {
  Future<AuthTokensModel> login(LoginRequestDto dto);
  Future<UserModel> register(RegisterRequestDto dto);
  Future<void> logout();
  Future<void> logoutAll();
  Future<AuthTokensModel> refreshToken(String refreshToken);
  Future<void> forgotPassword(ForgotPasswordRequestDto dto);
  Future<void> resetPassword(ResetPasswordRequestDto dto);
  Future<void> verifyEmail(VerifyEmailRequestDto dto);
  Future<void> resendVerification(String email);
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl extends BaseRemoteDataSource implements IAuthRemoteDataSource {
  AuthRemoteDataSourceImpl(super.apiClient);

  @override
  Future<AuthTokensModel> login(LoginRequestDto dto) async {
    final response = await apiClient.post(
      ApiConstants.login,
      data: dto.toJson(),
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final tokensData = (data['tokens'] as Map<String, dynamic>?) ?? data;
    return AuthTokensModel.fromJson(tokensData);
  }

  @override
  Future<UserModel> register(RegisterRequestDto dto) async {
    final response = await apiClient.post(
      ApiConstants.register,
      data: dto.toJson(),
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }

  @override
  Future<void> logout() async {
    await apiClient.post(ApiConstants.logout);
  }

  @override
  Future<void> logoutAll() async {
    await apiClient.post('/auth/logout-all');
  }

  @override
  Future<AuthTokensModel> refreshToken(String refreshToken) async {
    final response = await apiClient.post(
      ApiConstants.refreshToken,
      data: {'refreshToken': refreshToken},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final tokensData = (data['tokens'] as Map<String, dynamic>?) ?? data;
    return AuthTokensModel.fromJson(tokensData);
  }

  @override
  Future<void> forgotPassword(ForgotPasswordRequestDto dto) async {
    await apiClient.post(
      ApiConstants.forgotPassword,
      data: dto.toJson(),
    );
  }

  @override
  Future<void> resetPassword(ResetPasswordRequestDto dto) async {
    await apiClient.post(
      ApiConstants.resetPassword,
      data: dto.toJson(),
    );
  }

  @override
  Future<void> verifyEmail(VerifyEmailRequestDto dto) async {
    await apiClient.post(
      '/auth/verify-email',
      data: dto.toJson(),
    );
  }

  @override
  Future<void> resendVerification(String email) async {
    await apiClient.post(
      '/auth/resend-verification',
      data: {'email': email},
    );
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await apiClient.get(ApiConstants.profile);
    final data = response.data['data'] as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }
}
