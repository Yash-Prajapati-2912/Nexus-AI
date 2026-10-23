import 'package:equatable/equatable.dart';

enum UploadStatus { pending, uploading, success, failed }

/// Domain entity representing an in-flight upload task in the upload queue.
class UploadTask extends Equatable {
  final String id;
  final String filePath;
  final String fileName;
  final double progress; // 0.0 to 1.0
  final UploadStatus status;
  final String? errorMessage;

  const UploadTask({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.progress,
    required this.status,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [id, filePath, fileName, progress, status, errorMessage];
}
