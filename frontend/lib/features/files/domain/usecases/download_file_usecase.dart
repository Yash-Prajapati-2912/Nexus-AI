import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../repositories/i_file_repository.dart';

class DownloadFileUseCase implements UseCase<String, String> {
  final IFileRepository repository;

  DownloadFileUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(String fileId) {
    return repository.generateSignedUrl(fileId);
  }
}
