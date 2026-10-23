import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

class RegisterParams {
  final String email;
  final String password;
  final String fullName;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.fullName,
  });
}

class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final IAuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      password: params.password,
      fullName: params.fullName,
    );
  }
}
