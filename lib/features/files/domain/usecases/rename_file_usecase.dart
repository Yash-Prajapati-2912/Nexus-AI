import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/file_item.dart';
import '../repositories/i_file_repository.dart';

class RenameFileParams extends Equatable {
  final String fileId;
  final String newName;

  const RenameFileParams({required this.fileId, required this.newName});

  @override
  List<Object?> get props => [fileId, newName];
}

class RenameFileUseCase implements UseCase<FileItem, RenameFileParams> {
  final IFileRepository repository;

  RenameFileUseCase(this.repository);

  @override
  Future<Either<Failure, FileItem>> call(RenameFileParams params) {
    return repository.renameFile(params.fileId, params.newName);
  }
}
