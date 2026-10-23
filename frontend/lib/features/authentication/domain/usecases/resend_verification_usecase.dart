import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_auth_repository.dart';

class ResendVerificationParams {
  final String email;
  const ResendVerificationParams({required this.email});
}

class ResendVerificationUseCase implements UseCase<void, ResendVerificationParams> {
  final IAuthRepository repository;

  ResendVerificationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ResendVerificationParams params) async {
    return await repository.resendVerification(email: params.email);
  }
}
