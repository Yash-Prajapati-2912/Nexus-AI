import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/academic_profile.dart';
import '../repositories/i_profile_repository.dart';

class UpdateAcademicProfileUseCase implements UseCase<AcademicProfile, Map<String, dynamic>> {
  final IProfileRepository repository;

  UpdateAcademicProfileUseCase(this.repository);

  @override
  Future<Either<Failure, AcademicProfile>> call(Map<String, dynamic> params) {
    return repository.updateAcademicProfile(params);
  }
}
