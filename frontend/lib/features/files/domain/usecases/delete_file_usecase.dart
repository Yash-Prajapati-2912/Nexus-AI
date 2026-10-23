import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../repositories/i_file_repository.dart';

class DeleteFileUseCase implements UseCase<Unit, String> {
  final IFileRepository repository;

  DeleteFileUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String fileId) {
    return repository.deleteFile(fileId);
  }
}
