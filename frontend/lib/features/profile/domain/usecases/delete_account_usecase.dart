import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../repositories/i_profile_repository.dart';

class DeleteAccountUseCase implements UseCase<Unit, NoParams> {
  final IProfileRepository repository;

  DeleteAccountUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.deleteAccount();
  }
}
