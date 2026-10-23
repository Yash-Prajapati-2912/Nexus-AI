import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../entities/file_item.dart';
import '../entities/folder_item.dart';
import '../entities/storage_usage.dart';

abstract class IFileRepository {
  Future<Either<Failure, List<FileItem>>> getFiles({String? folder, int page = 1, int limit = 20});
  Future<Either<Failure, FileItem>> uploadFile(String filePath, String folder, String moduleName);
  Future<Either<Failure, List<FileItem>>> uploadMultipleFiles(List<String> filePaths, String folder, String moduleName);
  Future<Either<Failure, List<FolderItem>>> getFolders();
  Future<Either<Failure, FileItem>> getFileById(String fileId);
  Future<Either<Failure, FileItem>> renameFile(String fileId, String newName);
  Future<Either<Failure, Unit>> deleteFile(String fileId);
  Future<Either<Failure, Unit>> restoreFile(String fileId);
  Future<Either<Failure, String>> generateSignedUrl(String fileId);
  Future<Either<Failure, StorageUsage>> getStorageUsage();
  Future<Either<Failure, List<FileItem>>> searchFiles(String query);
}
