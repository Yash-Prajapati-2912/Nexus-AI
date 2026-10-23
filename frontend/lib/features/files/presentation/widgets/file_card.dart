import 'package:flutter/material.dart';
import '../../domain/entities/file_item.dart';
import 'file_badge.dart';

class FileCard extends StatelessWidget {
  final FileItem file;
  final VoidCallback onTap;
  final VoidCallback? onMore;

  const FileCard({
    super.key,
    required this.file,
    required this.onTap,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sizeKB = (file.sizeBytes / 1024).toStringAsFixed(1);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(_getFileIcon(file.extension), color: theme.colorScheme.primary, size: 20),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                file.fileName,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            FileBadge(extension: file.extension),
          ],
        ),
        subtitle: Text(
          '${file.folder} • $sizeKB KB',
          style: theme.textTheme.bodySmall,
        ),
        trailing: onMore != null
            ? IconButton(
                icon: const Icon(Icons.more_vert_rounded, size: 18),
                onPressed: onMore,
              )
            : null,
      ),
    );
  }

  IconData _getFileIcon(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Icons.image_rounded;
      case 'mp4':
      case 'mov':
        return Icons.video_library_rounded;
      case 'mp3':
      case 'wav':
        return Icons.audiotrack_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      case 'zip':
        return Icons.folder_zip_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }
}
