import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/files/domain/entities/file_item.dart';
import 'package:nexus_ai/features/files/presentation/bloc/file_bloc.dart';
import 'package:nexus_ai/features/files/presentation/pages/storage_usage_page.dart';

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
        child: const StorageUsagePage(),
      ),
    );
  }

  testWidgets('displays 0 files and 0 used storage when no files exist instead of fake 32 files fallback', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const FileLoadedState(files: [], folders: []),
    );

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    // Verify 0 files are displayed
    expect(find.text('0'), findsOneWidget); // Total Files: 0
    expect(find.text('32'), findsNothing); // Fake sample fileCount was 32
  });

  testWidgets('computes and displays actual storage usage for loaded files', (tester) async {
    final docFile = FileItem(
      id: 'f1',
      ownerId: 'u1',
      fileName: 'Doc.pdf',
      originalName: 'Doc.pdf',
      mimeType: 'application/pdf',
      extension: 'pdf',
      sizeBytes: 5242880, // 5 MB
      folder: 'Documents',
      moduleName: 'PLANNER',
      fileUrl: '',
      createdAt: DateTime.now(),
    );

    when(() => mockBloc.state).thenReturn(
      FileLoadedState(files: [docFile], folders: const []),
    );

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    expect(find.text('1'), findsOneWidget); // Total Files: 1
    expect(find.text('5 MB'), findsOneWidget); // Docs: 5 MB
  });
}
