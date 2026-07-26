import 'package:flutter/material.dart';
import '../../domain/entities/download_task.dart';
import '../widgets/download_card.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  final List<DownloadTask> _tasks = const [
    DownloadTask(id: 'd1', fileId: 'fl1', fileName: 'CS101_Lecture_Notes.pdf', progress: 1.0, status: DownloadStatus.SUCCESS),
    DownloadTask(id: 'd2', fileId: 'fl2', fileName: 'Budget_Report_2026.xlsx', progress: 0.65, status: DownloadStatus.DOWNLOADING),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Downloads')),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 12),
        itemCount: _tasks.length,
        itemBuilder: (context, index) => DownloadCard(task: _tasks[index]),
      ),
    );
  }
}
