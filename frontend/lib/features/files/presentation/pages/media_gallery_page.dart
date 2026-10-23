import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/file_item.dart';
import '../bloc/file_bloc.dart';
import '../widgets/media_grid.dart';

class MediaGalleryPage extends StatefulWidget {
  const MediaGalleryPage({super.key});

  @override
  State<MediaGalleryPage> createState() => _MediaGalleryPageState();
}

class _MediaGalleryPageState extends State<MediaGalleryPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<FileBloc>();
    if (bloc.state is! FileLoadedState) {
      bloc.add(const LoadFilesEvent());
    }
  }

  bool _isMedia(FileItem file) {
    final ext = file.extension.toLowerCase();
    final mime = file.mimeType.toLowerCase();
    return ['png', 'jpg', 'jpeg', 'webp', 'gif', 'bmp', 'svg'].contains(ext) ||
        ['mp4', 'mov', 'webm', 'mkv', 'avi'].contains(ext) ||
        mime.startsWith('image/') ||
        mime.startsWith('video/');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Media Gallery')),
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
                      'Failed to load media',
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
          final mediaFiles = files.where(_isMedia).toList();

          if (mediaFiles.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.photo_library_outlined, size: 36, color: theme.colorScheme.outline),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Media Uploaded Yet',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Photos, images, and videos uploaded to your storage will appear here.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            );
          }

          return MediaGrid(
            items: mediaFiles,
            onTap: (item) {
              final ext = item.extension.toLowerCase();
              if (['mp4', 'mov', 'webm', 'mkv', 'avi'].contains(ext) || item.mimeType.startsWith('video/')) {
                context.push(RouteNames.filesVideoPlayer, extra: item);
              } else {
                context.push(RouteNames.filesImageViewer, extra: item);
              }
            },
          );
        },
      ),
    );
  }
}
