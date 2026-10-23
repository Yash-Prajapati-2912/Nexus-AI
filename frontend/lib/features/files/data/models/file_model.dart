import '../../domain/entities/file_item.dart';

class FileModel extends FileItem {
  const FileModel({
    required super.id,
    required super.ownerId,
    required super.fileName,
    required super.originalName,
    required super.mimeType,
    required super.extension,
    required super.sizeBytes,
    required super.folder,
    required super.moduleName,
    required super.fileUrl,
    super.thumbnailUrl,
    super.isFavourite,
    super.isArchived,
    super.isDeleted,
    required super.createdAt,
    super.metadata,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'] as String? ?? '',
      ownerId: json['ownerId'] as String? ?? json['userId'] as String? ?? '',
      fileName: json['fileName'] as String? ?? json['name'] as String? ?? 'file',
      originalName: json['originalName'] as String? ?? json['fileName'] as String? ?? 'file',
      mimeType: json['mimeType'] as String? ?? 'application/octet-stream',
      extension: json['extension'] as String? ?? json['ext'] as String? ?? 'pdf',
      sizeBytes: json['sizeBytes'] as int? ?? json['size'] as int? ?? 1024,
      folder: json['folder'] as String? ?? 'Documents',
      moduleName: json['moduleName'] as String? ?? 'GENERAL',
      fileUrl: json['fileUrl'] as String? ?? json['url'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String?,
      isFavourite: json['isFavourite'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'fileName': fileName,
      'originalName': originalName,
      'mimeType': mimeType,
      'extension': extension,
      'sizeBytes': sizeBytes,
      'folder': folder,
      'moduleName': moduleName,
      'fileUrl': fileUrl,
      'thumbnailUrl': thumbnailUrl,
      'isFavourite': isFavourite,
      'isArchived': isArchived,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }
}
