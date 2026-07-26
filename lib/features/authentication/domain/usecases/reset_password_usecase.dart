import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_auth_repository.dart';

class ResetPasswordParams {
  final String token;
  final String newPassword;

  const ResetPasswordParams({required this.token, required this.newPassword});
}

class ResetPasswordUseCase implements UseCase<void, ResetPasswordParams> {
  final IAuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    return await repository.resetPassword(
      token: params.token,
      newPassword: params.newPassword,
    );
  }
}
