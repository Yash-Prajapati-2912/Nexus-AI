import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_tokens_entity.dart';
import '../repositories/i_auth_repository.dart';

class RefreshTokenParams {
  final String refreshToken;
  const RefreshTokenParams({required this.refreshToken});
}

class RefreshTokenUseCase implements UseCase<AuthTokensEntity, RefreshTokenParams> {
  final IAuthRepository repository;

  RefreshTokenUseCase(this.repository);

  @override
  Future<Either<Failure, AuthTokensEntity>> call(RefreshTokenParams params) async {
    return await repository.refreshToken(refreshToken: params.refreshToken);
  }
}
