import 'package:equatable/equatable.dart';

/// Domain entity representing a stored file or media document.
class FileItem extends Equatable {
  final String id;
  final String ownerId;
  final String fileName;
  final String originalName;
  final String mimeType;
  final String extension;
  final int sizeBytes;
  final String folder;
  final String moduleName; // PLANNER, FINANCE, MENTOR, PROFILE, SYSTEM
  final String fileUrl;
  final String? thumbnailUrl;
  final bool isFavourite;
  final bool isArchived;
  final bool isDeleted;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const FileItem({
    required this.id,
    required this.ownerId,
    required this.fileName,
    required this.originalName,
    required this.mimeType,
    required this.extension,
    required this.sizeBytes,
    required this.folder,
    required this.moduleName,
    required this.fileUrl,
    this.thumbnailUrl,
    this.isFavourite = false,
    this.isArchived = false,
    this.isDeleted = false,
    required this.createdAt,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        ownerId,
        fileName,
        originalName,
        mimeType,
        extension,
        sizeBytes,
        folder,
        moduleName,
        fileUrl,
        thumbnailUrl,
        isFavourite,
        isArchived,
        isDeleted,
        createdAt,
        metadata,
      ];
}
