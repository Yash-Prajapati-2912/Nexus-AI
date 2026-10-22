import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/file_item.dart';
import '../../domain/entities/storage_usage.dart';
import '../bloc/file_bloc.dart';
import '../widgets/storage_card.dart';

class StorageUsagePage extends StatefulWidget {
  const StorageUsagePage({super.key});

  @override
  State<StorageUsagePage> createState() => _StorageUsagePageState();
}

class _StorageUsagePageState extends State<StorageUsagePage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<FileBloc>();
    if (bloc.state is! FileLoadedState) {
      bloc.add(const LoadFilesEvent());
    }
  }

  StorageUsage _computeStorage(List<FileItem> files) {
    int imageBytes = 0;
    int documentBytes = 0;
    int mediaBytes = 0;
    int otherBytes = 0;
    int totalUsed = 0;

    for (final file in files) {
      totalUsed += file.sizeBytes;
      final ext = file.extension.toLowerCase();
      final mime = file.mimeType.toLowerCase();

      if (['png', 'jpg', 'jpeg', 'webp', 'gif', 'svg'].contains(ext) || mime.startsWith('image/')) {
        imageBytes += file.sizeBytes;
      } else if (['pdf', 'doc', 'docx', 'txt', 'md', 'xlsx', 'csv'].contains(ext) ||
          mime.startsWith('application/pdf') ||
          mime.startsWith('text/')) {
        documentBytes += file.sizeBytes;
      } else if (['mp4', 'mov', 'webm', 'mkv', 'avi', 'mp3', 'wav', 'ogg'].contains(ext) ||
          mime.startsWith('video/') ||
          mime.startsWith('audio/')) {
        mediaBytes += file.sizeBytes;
      } else {
        otherBytes += file.sizeBytes;
      }
    }

    return StorageUsage(
      usedBytes: totalUsed,
      totalBytes: 10737418240, // 10 GB
      imagesBytes: imageBytes,
      documentsBytes: documentBytes,
      mediaBytes: mediaBytes,
      otherBytes: otherBytes,
      fileCount: files.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Storage Usage')),
      body: BlocBuilder<FileBloc, FileState>(
        builder: (context, state) {
          if (state is FileLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FileFailureState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 48, color: theme.colorScheme.error),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load storage statistics',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(state.message, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context.read<FileBloc>().add(const LoadFilesEvent()),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final files = (state is FileLoadedState) ? state.files : <FileItem>[];
          final storage = _computeStorage(files);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              StorageCard(storage: storage),
            ],
          );
        },
      ),
    );
  }
}
