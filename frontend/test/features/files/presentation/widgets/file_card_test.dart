import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/files/domain/entities/file_item.dart';
import 'package:nexus_ai/features/files/presentation/widgets/file_card.dart';

void main() {
  final tFile = FileItem(
    id: 'fl1',
    ownerId: 'u1',
    fileName: 'CS101_Lecture_Notes.pdf',
    originalName: 'CS101.pdf',
    mimeType: 'application/pdf',
    extension: 'pdf',
    sizeBytes: 2450000,
    folder: 'Documents',
    moduleName: 'PLANNER',
    fileUrl: 'https://api.nexus-ai.com/files/cs101.pdf',
    createdAt: DateTime.now(),
  );

  testWidgets('FileCard displays fileName, folder, and extension badge', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FileCard(
            file: tFile,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('CS101_Lecture_Notes.pdf'), findsOneWidget);
    expect(find.text('PDF'), findsOneWidget);
  });
}
