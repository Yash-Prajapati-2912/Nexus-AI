import 'package:flutter/material.dart';

class AttachmentChip extends StatelessWidget {
  final String fileName;
  final VoidCallback? onDelete;

  const AttachmentChip({
    super.key,
    required this.fileName,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.attach_file_rounded, size: 16),
      label: Text(fileName, style: const TextStyle(fontSize: 12)),
      deleteIcon: onDelete != null ? const Icon(Icons.close_rounded, size: 14) : null,
      onDeleted: onDelete,
    );
  }
}
