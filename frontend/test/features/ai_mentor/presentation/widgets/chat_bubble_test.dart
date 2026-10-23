import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/ai_mentor/domain/entities/chat_message.dart';
import 'package:nexus_ai/features/ai_mentor/presentation/widgets/chat_bubble.dart';

void main() {
  final tMsg = ChatMessage(
    id: 'm1',
    conversationId: 'c1',
    sender: 'AI',
    content: 'Hello! Welcome to AI Mentor.',
    createdAt: DateTime.now(),
  );

  testWidgets('ChatBubble renders AI sender and content correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatBubble(message: tMsg),
        ),
      ),
    );

    expect(find.text('Nexus AI'), findsOneWidget);
    expect(find.text('Hello! Welcome to AI Mentor.'), findsOneWidget);
  });
}
