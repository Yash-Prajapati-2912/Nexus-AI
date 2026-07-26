import 'package:equatable/equatable.dart';

enum DownloadStatus { PENDING, DOWNLOADING, SUCCESS, FAILED }

/// Domain entity representing a download task in progress or completed.
class DownloadTask extends Equatable {
  final String id;
  final String fileId;
  final String fileName;
  final double progress; // 0.0 to 1.0
  final DownloadStatus status;
  final String? localSavePath;
  final String? errorMessage;

  const DownloadTask({
    required this.id,
    required this.fileId,
    required this.fileName,
    required this.progress,
    required this.status,
    this.localSavePath,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [id, fileId, fileName, progress, status, localSavePath, errorMessage];
}
