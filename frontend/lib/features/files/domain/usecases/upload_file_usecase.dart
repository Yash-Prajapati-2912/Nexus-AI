import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/file_item.dart';
import '../repositories/i_file_repository.dart';

class UploadFileParams extends Equatable {
  final String filePath;
  final String folder;
  final String moduleName;

  const UploadFileParams({
    required this.filePath,
    required this.folder,
    required this.moduleName,
  });

  @override
  List<Object?> get props => [filePath, folder, moduleName];
}

class UploadFileUseCase implements UseCase<FileItem, UploadFileParams> {
  final IFileRepository repository;

  UploadFileUseCase(this.repository);

  @override
  Future<Either<Failure, FileItem>> call(UploadFileParams params) {
    return repository.uploadFile(params.filePath, params.folder, params.moduleName);
  }
}
