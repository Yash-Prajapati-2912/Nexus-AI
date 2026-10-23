import 'package:flutter/material.dart';
import '../../domain/entities/file_item.dart';

class PdfViewerPage extends StatelessWidget {
  final FileItem? file;

  const PdfViewerPage({super.key, this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(file?.fileName ?? 'PDF Document Viewer')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.picture_as_pdf_rounded, size: 80, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(file?.fileName ?? 'Document.pdf', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              const Text('Rendering PDF pages... Page 1 of 12'),
            ],
          ),
        ),
      ),
    );
  }
}
