import 'package:flutter/material.dart';
import '../../domain/entities/upload_task.dart';
import '../widgets/upload_progress_card.dart';

class UploadQueuePage extends StatelessWidget {
  const UploadQueuePage({super.key});

  final List<UploadTask> _tasks = const [
    UploadTask(id: 'u1', filePath: '/path/doc.pdf', fileName: 'CS101_Submission.pdf', progress: 0.8, status: UploadStatus.UPLOADING),
    UploadTask(id: 'u2', filePath: '/path/img.png', fileName: 'Whiteboard_Scan.png', progress: 1.0, status: UploadStatus.SUCCESS),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Queue')),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 12),
        itemCount: _tasks.length,
        itemBuilder: (context, index) => UploadProgressCard(task: _tasks[index]),
      ),
    );
  }
}
