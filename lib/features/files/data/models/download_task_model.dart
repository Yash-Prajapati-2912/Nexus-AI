import '../../domain/entities/download_task.dart';

class DownloadTaskModel extends DownloadTask {
  const DownloadTaskModel({
    required super.id,
    required super.fileId,
    required super.fileName,
    required super.progress,
    required super.status,
    super.localSavePath,
    super.errorMessage,
  });

  factory DownloadTaskModel.fromJson(Map<String, dynamic> json) {
    return DownloadTaskModel(
      id: json['id'] as String? ?? '',
      fileId: json['fileId'] as String? ?? '',
      fileName: json['fileName'] as String? ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      status: DownloadStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['status'] as String? ?? 'pending').toLowerCase(),
        orElse: () => DownloadStatus.pending,
      ),
      localSavePath: json['localSavePath'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileId': fileId,
      'fileName': fileName,
      'progress': progress,
      'status': status.name,
      'localSavePath': localSavePath,
      'errorMessage': errorMessage,
    };
  }
}
