import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_auth_repository.dart';

class LogoutAllUseCase implements UseCase<void, NoParams> {
  final IAuthRepository repository;

  LogoutAllUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logoutAll();
  }
}
