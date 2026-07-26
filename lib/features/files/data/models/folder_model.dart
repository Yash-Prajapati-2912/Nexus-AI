import '../../domain/entities/folder_item.dart';

class FolderModel extends FolderItem {
  const FolderModel({
    required super.id,
    required super.ownerId,
    required super.name,
    required super.itemCount,
    required super.totalSizeBytes,
    required super.createdAt,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      id: json['id'] as String? ?? json['folder'] as String? ?? 'f1',
      ownerId: json['ownerId'] as String? ?? '',
      name: json['name'] as String? ?? json['folder'] as String? ?? 'Documents',
      itemCount: json['itemCount'] as int? ?? json['count'] as int? ?? 0,
      totalSizeBytes: json['totalSizeBytes'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'itemCount': itemCount,
      'totalSizeBytes': totalSizeBytes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
