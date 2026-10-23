import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../repositories/i_profile_repository.dart';

class UploadAvatarUseCase implements UseCase<String, String> {
  final IProfileRepository repository;

  UploadAvatarUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(String imagePath) {
    return repository.uploadAvatar(imagePath);
  }
}
