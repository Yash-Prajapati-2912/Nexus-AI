import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/exceptions.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/features/files/data/datasources/file_remote_data_source.dart';
import 'package:nexus_ai/features/files/domain/entities/file_item.dart';
import 'package:nexus_ai/features/files/domain/entities/folder_item.dart';
import 'package:nexus_ai/features/files/domain/entities/storage_usage.dart';
import 'package:nexus_ai/features/files/domain/repositories/i_file_repository.dart';

class FileRepositoryImpl implements IFileRepository {
  final IFileRemoteDataSource remoteDataSource;

  FileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FileItem>>> getFiles({String? folder, int page = 1, int limit = 20}) async {
    try {
      final list = await remoteDataSource.getFiles(folder: folder, page: page, limit: limit);
      return Right(list);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FileItem>> uploadFile(String filePath, String folder, String moduleName) async {
    try {
      final file = await remoteDataSource.uploadFile(filePath, folder, moduleName);
      return Right(file);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<FileItem>>> uploadMultipleFiles(List<String> filePaths, String folder, String moduleName) async {
    try {
      final list = await remoteDataSource.uploadMultipleFiles(filePaths, folder, moduleName);
      return Right(list);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<FolderItem>>> getFolders() async {
    try {
      final list = await remoteDataSource.getFolders();
      return Right(list);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FileItem>> getFileById(String fileId) async {
    try {
      final file = await remoteDataSource.getFileById(fileId);
      return Right(file);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FileItem>> renameFile(String fileId, String newName) async {
    try {
      final file = await remoteDataSource.updateFile(fileId, {'fileName': newName});
      return Right(file);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteFile(String fileId) async {
    try {
      await remoteDataSource.deleteFile(fileId);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> restoreFile(String fileId) async {
    try {
      await remoteDataSource.restoreFile(fileId);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> generateSignedUrl(String fileId) async {
    try {
      final url = await remoteDataSource.generateSignedUrl(fileId);
      return Right(url);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, StorageUsage>> getStorageUsage() async {
    try {
      final storage = await remoteDataSource.getStorageUsage();
      return Right(storage);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<FileItem>>> searchFiles(String query) async {
    try {
      final all = await remoteDataSource.getFiles(limit: 100);
      final q = query.toLowerCase();
      final filtered = all.where((f) => f.fileName.toLowerCase().contains(q) || f.extension.toLowerCase().contains(q)).toList();
      return Right(filtered);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(Object e) {
    if (e is ValidationException) {
      return ValidationFailure(message: e.message, fieldErrors: e.errors);
    } else if (e is UnauthorizedException) {
      return const UnauthorizedFailure();
    } else if (e is ServerException) {
      return ServerFailure(message: e.message, statusCode: e.statusCode);
    } else if (e is NetworkException) {
      return NetworkFailure(message: e.message);
    } else {
      return UnknownFailure(message: e.toString());
    }
  }
}
