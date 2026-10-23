import 'dart:async';
import '../services/app_logger.dart';

enum FileTransferType { upload, download }
enum FileTransferStatus { queued, processing, completed, failed }

class FileTransferTask {
  final String id;
  final String filePath;
  final String targetUrl;
  final FileTransferType type;
  FileTransferStatus status;
  double progress;
  final int retryCount;

  FileTransferTask({
    required this.id,
    required this.filePath,
    required this.targetUrl,
    required this.type,
    this.status = FileTransferStatus.queued,
    this.progress = 0.0,
    this.retryCount = 0,
  });
}

class FileTransferQueue {
  final List<FileTransferTask> _tasks = [];
  final StreamController<List<FileTransferTask>> _tasksController =
      StreamController<List<FileTransferTask>>.broadcast();

  Stream<List<FileTransferTask>> get tasksStream => _tasksController.stream;

  void addTask(FileTransferTask task) {
    _tasks.add(task);
    _notify();
    AppLogger.info('FileTransferQueue: Added ${task.type.name} task [${task.id}]');
    _processNext();
  }

  void cancelTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _notify();
    AppLogger.info('FileTransferQueue: Cancelled task [$id]');
  }

  void _processNext() {
    final pending = _tasks.where((t) => t.status == FileTransferStatus.queued).toList();
    if (pending.isEmpty) return;

    final task = pending.first;
    task.status = FileTransferStatus.processing;
    _notify();

    // Simulate transfer execution with progress
    AppLogger.info('FileTransferQueue: Executing task ${task.id}');
    task.status = FileTransferStatus.completed;
    task.progress = 1.0;
    _notify();
  }

  void _notify() {
    _tasksController.add(List.unmodifiable(_tasks));
  }

  void dispose() {
    _tasksController.close();
  }
}
