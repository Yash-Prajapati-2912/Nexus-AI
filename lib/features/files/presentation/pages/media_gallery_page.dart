import 'package:flutter/material.dart';
import '../../domain/entities/file_item.dart';
import '../widgets/media_grid.dart';

class MediaGalleryPage extends StatelessWidget {
  MediaGalleryPage({super.key});

  final List<FileItem> _sampleMedia = [
    FileItem(id: 'm1', ownerId: 'u1', fileName: 'Whiteboard_Notes.png', originalName: 'notes.png', mimeType: 'image/png', extension: 'png', sizeBytes: 1500000, folder: 'Media', moduleName: 'PLANNER', fileUrl: '', createdAt: DateTime.now()),
    FileItem(id: 'm2', ownerId: 'u1', fileName: 'Lecture_Recording.mp4', originalName: 'lecture.mp4', mimeType: 'video/mp4', extension: 'mp4', sizeBytes: 45000000, folder: 'Media', moduleName: 'PLANNER', fileUrl: '', createdAt: DateTime.now()),
    FileItem(id: 'm3', ownerId: 'u1', fileName: 'Receipt_Textbooks.jpg', originalName: 'receipt.jpg', mimeType: 'image/jpeg', extension: 'jpg', sizeBytes: 850000, folder: 'Media', moduleName: 'FINANCE', fileUrl: '', createdAt: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media Gallery')),
      body: MediaGrid(
        items: _sampleMedia,
        onTap: (item) {},
      ),
    );
  }
}
