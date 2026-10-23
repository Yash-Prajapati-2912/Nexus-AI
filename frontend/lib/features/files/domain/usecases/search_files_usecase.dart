import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/file_item.dart';
import '../repositories/i_file_repository.dart';

class SearchFilesUseCase implements UseCase<List<FileItem>, String> {
  final IFileRepository repository;

  SearchFilesUseCase(this.repository);

  @override
  Future<Either<Failure, List<FileItem>>> call(String query) {
    return repository.searchFiles(query);
  }
}
