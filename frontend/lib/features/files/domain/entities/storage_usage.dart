import 'package:equatable/equatable.dart';

/// Domain entity representing storage space analytics.
class StorageUsage extends Equatable {
  final int usedBytes;
  final int totalBytes;
  final int imagesBytes;
  final int documentsBytes;
  final int mediaBytes;
  final int otherBytes;
  final int fileCount;

  const StorageUsage({
    required this.usedBytes,
    required this.totalBytes,
    required this.imagesBytes,
    required this.documentsBytes,
    required this.mediaBytes,
    required this.otherBytes,
    required this.fileCount,
  });

  @override
  List<Object?> get props => [
        usedBytes,
        totalBytes,
        imagesBytes,
        documentsBytes,
        mediaBytes,
        otherBytes,
        fileCount,
      ];
}
