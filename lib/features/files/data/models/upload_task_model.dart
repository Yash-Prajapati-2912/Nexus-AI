import '../../domain/entities/upload_task.dart';

class UploadTaskModel extends UploadTask {
  const UploadTaskModel({
    required super.id,
    required super.filePath,
    required super.fileName,
    required super.progress,
    required super.status,
    super.errorMessage,
  });

  factory UploadTaskModel.fromJson(Map<String, dynamic> json) {
    return UploadTaskModel(
      id: json['id'] as String? ?? '',
      filePath: json['filePath'] as String? ?? '',
      fileName: json['fileName'] as String? ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      status: UploadStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'PENDING'),
        orElse: () => UploadStatus.PENDING,
      ),
      errorMessage: json['errorMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'fileName': fileName,
      'progress': progress,
      'status': status.name,
      'errorMessage': errorMessage,
    };
  }
}
