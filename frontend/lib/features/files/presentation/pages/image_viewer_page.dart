import 'package:flutter/material.dart';
import '../../domain/entities/file_item.dart';

class ImageViewerPage extends StatelessWidget {
  final FileItem? file;

  const ImageViewerPage({super.key, this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(file?.fileName ?? 'Image Preview'),
      ),
      body: Center(
        child: InteractiveViewer(
          child: (file != null && file!.fileUrl.isNotEmpty)
              ? Image.network(file!.fileUrl, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_rounded, size: 80, color: Colors.white54))
              : const Icon(Icons.image_rounded, size: 100, color: Colors.white54),
        ),
      ),
    );
  }
}
