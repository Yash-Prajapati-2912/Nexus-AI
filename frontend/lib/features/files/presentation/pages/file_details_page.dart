import 'package:flutter/material.dart';
import '../../domain/entities/file_item.dart';
import '../widgets/preview_card.dart';

class FileDetailsPage extends StatelessWidget {
  final FileItem? file;

  const FileDetailsPage({super.key, this.file});

  @override
  Widget build(BuildContext context) {
    final fl = file ?? FileItem(
      id: 'd1',
      ownerId: 'u1',
      fileName: 'CS101_Lecture_Notes.pdf',
      originalName: 'CS101.pdf',
      mimeType: 'application/pdf',
      extension: 'pdf',
      sizeBytes: 2450000,
      folder: 'Documents',
      moduleName: 'PLANNER',
      fileUrl: '',
      createdAt: DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('File Details')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            PreviewCard(file: fl),
            const SizedBox(height: 20),
            ListTile(title: const Text('Folder'), subtitle: Text(fl.folder)),
            ListTile(title: const Text('Module'), subtitle: Text(fl.moduleName)),
            ListTile(title: const Text('Size'), subtitle: Text('${(fl.sizeBytes / 1024).toStringAsFixed(1)} KB')),
          ],
        ),
      ),
    );
  }
}
