import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/i_profile_repository.dart';

class UpdateProfileUseCase implements UseCase<UserProfile, Map<String, dynamic>> {
  final IProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(Map<String, dynamic> params) {
    return repository.updateProfile(params);
  }
}
