import 'package:dio/dio.dart';
import 'package:nexus_ai/core/network/api_client.dart';
import '../models/file_model.dart';
import '../models/folder_model.dart';
import '../models/storage_usage_model.dart';

abstract class IFileRemoteDataSource {
  Future<List<FileModel>> getFiles({String? folder, int page = 1, int limit = 20});
  Future<FileModel> uploadFile(String filePath, String folder, String moduleName);
  Future<List<FileModel>> uploadMultipleFiles(List<String> filePaths, String folder, String moduleName);
  Future<List<FolderModel>> getFolders();
  Future<FileModel> getFileById(String fileId);
  Future<FileModel> updateFile(String fileId, Map<String, dynamic> body);
  Future<void> deleteFile(String fileId);
  Future<void> restoreFile(String fileId);
  Future<String> generateSignedUrl(String fileId, {int expiresIn = 3600});
  Future<StorageUsageModel> getStorageUsage();
}

class FileRemoteDataSourceImpl implements IFileRemoteDataSource {
  final ApiClient _apiClient;

  FileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<FileModel>> getFiles({String? folder, int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '/media',
      queryParameters: {
        if (folder != null) 'folder': folder,
        'page': page,
        'limit': limit,
      },
    );
    final rawData = response.data;
    List<dynamic> list = [];
    if (rawData is List<dynamic>) {
      list = rawData;
    } else if (rawData is Map<String, dynamic> && rawData['data'] is List<dynamic>) {
      list = rawData['data'] as List<dynamic>;
    }
    return list.map((e) => FileModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<FileModel> uploadFile(String filePath, String folder, String moduleName) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
      'folder': folder,
      'moduleName': moduleName,
    });
    final response = await _apiClient.post('/media/upload', data: formData);
    final data = response.data as Map<String, dynamic>;
    return FileModel.fromJson(data);
  }

  @override
  Future<List<FileModel>> uploadMultipleFiles(List<String> filePaths, String folder, String moduleName) async {
    final files = <MultipartFile>[];
    for (final path in filePaths) {
      files.add(await MultipartFile.fromFile(path));
    }
    final formData = FormData.fromMap({
      'files': files,
      'folder': folder,
      'moduleName': moduleName,
    });
    final response = await _apiClient.post('/media/upload/multiple', data: formData);
    final rawData = response.data;
    final list = rawData is List<dynamic> ? rawData : [];
    return list.map((e) => FileModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<FolderModel>> getFolders() async {
    final response = await _apiClient.get('/media/folders');
    final rawData = response.data;
    final list = rawData is List<dynamic> ? rawData : [];
    return list.map((e) => FolderModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<FileModel> getFileById(String fileId) async {
    final response = await _apiClient.get('/media/$fileId');
    final data = response.data as Map<String, dynamic>;
    return FileModel.fromJson(data);
  }

  @override
  Future<FileModel> updateFile(String fileId, Map<String, dynamic> body) async {
    final response = await _apiClient.patch('/media/$fileId', data: body);
    final data = response.data as Map<String, dynamic>;
    return FileModel.fromJson(data);
  }

  @override
  Future<void> deleteFile(String fileId) async {
    await _apiClient.delete('/media/$fileId');
  }

  @override
  Future<void> restoreFile(String fileId) async {
    await _apiClient.post('/media/$fileId/restore', data: {});
  }

  @override
  Future<String> generateSignedUrl(String fileId, {int expiresIn = 3600}) async {
    final response = await _apiClient.get('/media/$fileId/signed-url', queryParameters: {'expiresIn': expiresIn});
    final data = response.data as Map<String, dynamic>;
    return data['signedUrl'] as String? ?? '';
  }

  @override
  Future<StorageUsageModel> getStorageUsage() async {
    final response = await _apiClient.get('/media/storage');
    final data = response.data as Map<String, dynamic>;
    return StorageUsageModel.fromJson(data);
  }
}
