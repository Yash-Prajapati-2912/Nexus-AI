import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_auth_repository.dart';

class ForgotPasswordParams {
  final String email;
  const ForgotPasswordParams({required this.email});
}

class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  final IAuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    return await repository.forgotPassword(email: params.email);
  }
}
