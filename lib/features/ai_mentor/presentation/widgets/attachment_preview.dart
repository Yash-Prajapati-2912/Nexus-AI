import 'package:flutter/material.dart';
import '../../domain/entities/chat_attachment.dart';

class AttachmentPreview extends StatelessWidget {
  final ChatAttachment attachment;
  final VoidCallback? onRemove;

  const AttachmentPreview({super.key, required this.attachment, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.attach_file_rounded, size: 16),
          const SizedBox(width: 6),
          Text(attachment.fileName, style: theme.textTheme.bodySmall),
          if (onRemove != null) ...[
            const SizedBox(width: 6),
            InkWell(
              onTap: onRemove,
              child: const Icon(Icons.close_rounded, size: 14),
            ),
          ],
        ],
      ),
    );
  }
}
