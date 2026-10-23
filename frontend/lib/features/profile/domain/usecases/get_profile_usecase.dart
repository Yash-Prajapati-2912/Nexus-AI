import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/i_profile_repository.dart';

class GetProfileUseCase implements UseCase<UserProfile, NoParams> {
  final IProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(NoParams params) {
    return repository.getProfile();
  }
}
