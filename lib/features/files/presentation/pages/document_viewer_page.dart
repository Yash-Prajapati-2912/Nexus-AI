import 'package:flutter/material.dart';
import '../../domain/entities/file_item.dart';

class DocumentViewerPage extends StatelessWidget {
  final FileItem? file;

  const DocumentViewerPage({super.key, this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(file?.fileName ?? 'Document Viewer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(file?.fileName ?? 'Notes.md', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Divider(),
            const Text('# Nexus AI Study Notes\n\n- Data Structures & Algorithms\n- Time Complexity: O(log N)\n- Space Complexity: O(1)'),
          ],
        ),
      ),
    );
  }
}
