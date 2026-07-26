import 'package:equatable/equatable.dart';

/// Domain entity representing a media/file folder.
class FolderItem extends Equatable {
  final String id;
  final String ownerId;
  final String name;
  final int itemCount;
  final int totalSizeBytes;
  final DateTime createdAt;

  const FolderItem({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.itemCount,
    required this.totalSizeBytes,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, ownerId, name, itemCount, totalSizeBytes, createdAt];
}
