import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/files/domain/entities/file_item.dart';
import 'package:nexus_ai/features/files/domain/entities/folder_item.dart';
import 'package:nexus_ai/features/files/presentation/bloc/file_bloc.dart';
import 'package:nexus_ai/features/files/presentation/pages/file_manager_page.dart';

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
        child: const FileManagerPage(),
      ),
    );
  }

  testWidgets('renders honest empty states when files and folders lists are empty', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const FileLoadedState(files: [], folders: []),
    );

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    // Verify empty state placeholders
    expect(find.text('No folders created yet'), findsOneWidget);
    expect(find.text('No files uploaded yet'), findsOneWidget);

    // Verify hardcoded sample files/folders are NOT displayed
    expect(find.text('CS101_Lecture_Notes.pdf'), findsNothing);
    expect(find.text('Budget_Report_2026.xlsx'), findsNothing);
    expect(find.text('AI_Mentor_Summary.md'), findsNothing);
  });

  testWidgets('renders real folder and real file when available in state', (tester) async {
    final realFolder = FolderItem(
      id: 'f100',
      ownerId: 'u1',
      name: 'Research Papers',
      itemCount: 3,
      totalSizeBytes: 10240,
      createdAt: DateTime.now(),
    );

    final realFile = FileItem(
      id: 'fl100',
      ownerId: 'u1',
      fileName: 'Thesis_Draft.pdf',
      originalName: 'Thesis_Draft.pdf',
      mimeType: 'application/pdf',
      extension: 'pdf',
      sizeBytes: 500000,
      folder: 'Research Papers',
      moduleName: 'PLANNER',
      fileUrl: 'https://example.com/thesis.pdf',
      createdAt: DateTime.now(),
    );

    when(() => mockBloc.state).thenReturn(
      FileLoadedState(files: [realFile], folders: [realFolder]),
    );

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    expect(find.text('Research Papers'), findsOneWidget);
    expect(find.text('Thesis_Draft.pdf'), findsOneWidget);
    expect(find.text('No folders created yet'), findsNothing);
    expect(find.text('No files uploaded yet'), findsNothing);
  });

  testWidgets('renders error view on FileFailureState', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const FileFailureState('Server unreachable'),
    );

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    expect(find.text('Failed to load files'), findsOneWidget);
    expect(find.text('Server unreachable'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
