import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_auth_repository.dart';

class VerifyEmailParams {
  final String token;
  const VerifyEmailParams({required this.token});
}

class VerifyEmailUseCase implements UseCase<void, VerifyEmailParams> {
  final IAuthRepository repository;

  VerifyEmailUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(VerifyEmailParams params) async {
    return await repository.verifyEmail(token: params.token);
  }
}
