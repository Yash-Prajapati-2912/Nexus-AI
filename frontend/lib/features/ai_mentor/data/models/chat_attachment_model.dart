import '../../domain/entities/chat_attachment.dart';

class ChatAttachmentModel extends ChatAttachment {
  const ChatAttachmentModel({
    required super.id,
    required super.fileName,
    required super.fileType,
    required super.fileUrl,
    super.localPath,
    required super.fileSize,
  });

  factory ChatAttachmentModel.fromJson(Map<String, dynamic> json) {
    return ChatAttachmentModel(
      id: json['id'] as String? ?? '',
      fileName: json['fileName'] as String? ?? json['name'] as String? ?? 'Attachment',
      fileType: json['fileType'] as String? ?? json['type'] as String? ?? 'FILE',
      fileUrl: json['fileUrl'] as String? ?? json['url'] as String? ?? '',
      localPath: json['localPath'] as String?,
      fileSize: json['fileSize'] as int? ?? json['size'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileType': fileType,
      'fileUrl': fileUrl,
      'localPath': localPath,
      'fileSize': fileSize,
    };
  }
}
