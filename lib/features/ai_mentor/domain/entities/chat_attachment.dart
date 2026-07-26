import 'package:equatable/equatable.dart';

/// Domain entity representing a message file attachment.
class ChatAttachment extends Equatable {
  final String id;
  final String fileName;
  final String fileType; // IMAGE, PDF, TEXT, AUDIO
  final String fileUrl;
  final String? localPath;
  final int fileSize; // bytes

  const ChatAttachment({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.fileUrl,
    this.localPath,
    required this.fileSize,
  });

  @override
  List<Object?> get props => [id, fileName, fileType, fileUrl, localPath, fileSize];
}
