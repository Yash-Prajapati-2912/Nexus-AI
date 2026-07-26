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

  final List<FolderItem> _sampleFolders = [
    FolderItem(id: 'f1', ownerId: 'u1', name: 'Documents', itemCount: 12, totalSizeBytes: 45000000, createdAt: DateTime.now()),
    FolderItem(id: 'f2', ownerId: 'u1', name: 'Assignments', itemCount: 8, totalSizeBytes: 25000000, createdAt: DateTime.now()),
    FolderItem(id: 'f3', ownerId: 'u1', name: 'Media', itemCount: 24, totalSizeBytes: 95000000, createdAt: DateTime.now()),
  ];

  final List<FileItem> _sampleFiles = [
    FileItem(id: 'fl1', ownerId: 'u1', fileName: 'CS101_Lecture_Notes.pdf', originalName: 'CS101.pdf', mimeType: 'application/pdf', extension: 'pdf', sizeBytes: 2450000, folder: 'Documents', moduleName: 'PLANNER', fileUrl: 'https://api.nexus-ai.com/files/cs101.pdf', createdAt: DateTime.now()),
    FileItem(id: 'fl2', ownerId: 'u1', fileName: 'Budget_Report_2026.xlsx', originalName: 'budget.xlsx', mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', extension: 'xlsx', sizeBytes: 1200000, folder: 'Finance', moduleName: 'FINANCE', fileUrl: 'https://api.nexus-ai.com/files/budget.xlsx', createdAt: DateTime.now()),
    FileItem(id: 'fl3', ownerId: 'u1', fileName: 'AI_Mentor_Summary.md', originalName: 'summary.md', mimeType: 'text/markdown', extension: 'md', sizeBytes: 14000, folder: 'Documents', moduleName: 'MENTOR', fileUrl: 'https://api.nexus-ai.com/files/summary.md', createdAt: DateTime.now()),
  ];

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
            final folders = (state is FileLoadedState && state.folders.isNotEmpty) ? state.folders : _sampleFolders;
            final files = (state is FileLoadedState && state.files.isNotEmpty) ? state.files : _sampleFiles;

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
                        ActionChip(
                          avatar: const Icon(Icons.delete_rounded, size: 16),
                          label: const Text('Trash'),
                          onPressed: () => context.push(RouteNames.filesTrash),
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
