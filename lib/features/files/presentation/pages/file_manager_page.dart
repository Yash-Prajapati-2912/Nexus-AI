import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/file_item.dart';
import '../../domain/entities/folder_item.dart';
import '../bloc/file_bloc.dart';
import '../widgets/file_card.dart';
import '../widgets/folder_card.dart';

class FileManagerPage extends StatefulWidget {
  const FileManagerPage({super.key});

  @override
  State<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
  @override
  void initState() {
    super.initState();
    context.read<FileBloc>().add(const LoadFilesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('File Manager', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.push(RouteNames.filesSearch),
          ),
          IconButton(
            icon: const Icon(Icons.pie_chart_rounded),
            onPressed: () => context.push(RouteNames.filesStorageUsage),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<FileBloc>().add(const LoadFilesEvent());
        },
        child: BlocBuilder<FileBloc, FileState>(
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
                        'Failed to load files',
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

            final folders = (state is FileLoadedState) ? state.folders : <FolderItem>[];
            final files = (state is FileLoadedState) ? state.files : <FileItem>[];

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Folders Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Folders', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  if (folders.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.folder_open_rounded, color: theme.colorScheme.outline),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'No folders created yet',
                                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: folders.length,
                      itemBuilder: (context, index) {
                        final f = folders[index];
                        return FolderCard(
                          folder: f,
                          onTap: () => context.push(RouteNames.filesMediaGallery),
                        );
                      },
                    ),

                  const SizedBox(height: 20),

                  // Quick Action Chips
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.photo_library_rounded, size: 16),
                          label: const Text('Media Gallery'),
                          onPressed: () => context.push(RouteNames.filesMediaGallery),
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.cloud_upload_rounded, size: 16),
                          label: const Text('Upload Queue'),
                          onPressed: () => context.push(RouteNames.filesUploadQueue),
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.download_rounded, size: 16),
                          label: const Text('Downloads'),
                          onPressed: () => context.push(RouteNames.filesDownloads),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Recent Files List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Recent Files', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  if (files.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.insert_drive_file_outlined, size: 40, color: theme.colorScheme.outline),
                            const SizedBox(height: 8),
                            Text('No files uploaded yet', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Uploaded files will appear here.', style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        final fl = files[index];
                        return FileCard(
                          file: fl,
                          onTap: () => _openViewer(context, fl),
                          onMore: () => context.push(RouteNames.filesDetails, extra: fl),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.upload_file_rounded),
        label: const Text('Upload File'),
        onPressed: () => context.push(RouteNames.filesUploadQueue),
      ),
    );
  }

  void _openViewer(BuildContext context, FileItem file) {
    final ext = file.extension.toLowerCase();
    if (['png', 'jpg', 'jpeg', 'webp'].contains(ext)) {
      context.push(RouteNames.filesImageViewer, extra: file);
    } else if (ext == 'pdf') {
      context.push(RouteNames.filesPdfViewer, extra: file);
    } else if (['mp4', 'mov'].contains(ext)) {
      context.push(RouteNames.filesVideoPlayer, extra: file);
    } else if (['mp3', 'wav'].contains(ext)) {
      context.push(RouteNames.filesAudioPlayer, extra: file);
    } else {
      context.push(RouteNames.filesDocumentViewer, extra: file);
    }
  }
}
