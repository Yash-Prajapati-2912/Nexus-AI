import 'package:flutter/material.dart';
import '../../domain/entities/download_task.dart';
import '../widgets/download_card.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DownloadTask> tasks = [];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Downloads')),
      body: tasks.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_download_outlined,
                      size: 64,
                      color: isDark ? Colors.white38 : Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Downloads Found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Files you download will appear here for offline access.',
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
              itemBuilder: (context, index) => DownloadCard(task: tasks[index]),
            ),
    );
  }
}
