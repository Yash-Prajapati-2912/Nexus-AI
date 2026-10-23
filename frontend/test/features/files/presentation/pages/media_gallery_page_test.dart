import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/files/domain/entities/file_item.dart';
import 'package:nexus_ai/features/files/presentation/bloc/file_bloc.dart';
import 'package:nexus_ai/features/files/presentation/pages/media_gallery_page.dart';

class MockFileBloc extends MockBloc<FileEvent, FileState> implements FileBloc {}

void main() {
  late MockFileBloc mockBloc;

  setUp(() {
    mockBloc = MockFileBloc();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<FileBloc>.value(
        value: mockBloc,
        child: const MediaGalleryPage(),
      ),
    );
  }

  testWidgets('renders honest empty state and no hardcoded demo media when files list is empty', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const FileLoadedState(files: [], folders: []),
    );

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    // Verify empty state is rendered
    expect(find.text('No Media Uploaded Yet'), findsOneWidget);

    // Verify hardcoded demo media are NOT present
    expect(find.text('Whiteboard_Notes.png'), findsNothing);
    expect(find.text('Lecture_Recording.mp4'), findsNothing);
    expect(find.text('Receipt_Textbooks.jpg'), findsNothing);
  });

  testWidgets('renders real media file in grid when media file is loaded', (tester) async {
    final mediaFile = FileItem(
      id: 'm100',
      ownerId: 'u1',
      fileName: 'Campus_Sunset.jpg',
      originalName: 'Campus_Sunset.jpg',
      mimeType: 'image/jpeg',
      extension: 'jpg',
      sizeBytes: 1200000,
      folder: 'Media',
      moduleName: 'PLANNER',
      fileUrl: 'https://example.com/sunset.jpg',
      createdAt: DateTime.now(),
    );

    when(() => mockBloc.state).thenReturn(
      FileLoadedState(files: [mediaFile], folders: const []),
    );

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    expect(find.text('Campus_Sunset.jpg'), findsOneWidget);
    expect(find.text('No Media Uploaded Yet'), findsNothing);
  });
}
