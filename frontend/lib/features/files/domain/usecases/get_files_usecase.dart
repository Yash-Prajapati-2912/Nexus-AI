import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/file_item.dart';
import '../repositories/i_file_repository.dart';

class GetFilesParams extends Equatable {
  final String? folder;
  final int page;
  final int limit;

  const GetFilesParams({this.folder, this.page = 1, this.limit = 20});

  @override
  List<Object?> get props => [folder, page, limit];
}

class GetFilesUseCase implements UseCase<List<FileItem>, GetFilesParams> {
  final IFileRepository repository;

  GetFilesUseCase(this.repository);

  @override
  Future<Either<Failure, List<FileItem>>> call(GetFilesParams params) {
    return repository.getFiles(folder: params.folder, page: params.page, limit: params.limit);
  }
}
