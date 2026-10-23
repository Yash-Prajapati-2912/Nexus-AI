import 'package:flutter/material.dart';
import '../../domain/entities/upload_task.dart';
import '../widgets/upload_progress_card.dart';

class UploadQueuePage extends StatelessWidget {
  const UploadQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<UploadTask> tasks = [];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Queue')),
      body: tasks.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 64,
                      color: isDark ? Colors.white38 : Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Uploads in Queue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'All file uploads have completed successfully.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 12),
              itemCount: tasks.length,
              itemBuilder: (context, index) => UploadProgressCard(task: tasks[index]),
            ),
    );
  }
}
