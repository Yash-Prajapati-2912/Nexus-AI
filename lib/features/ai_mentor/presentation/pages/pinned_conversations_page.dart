import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/conversation.dart';
import '../widgets/conversation_card.dart';

class PinnedConversationsPage extends StatelessWidget {
  const PinnedConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Conversation> pinned = [
      Conversation(id: 'c1', title: 'Midterm Prep Strategy', isPinned: true, createdAt: DateTime.now(), updatedAt: DateTime.now(), messageCount: 12, lastMessageSnippet: 'Focus on trees & graphs', topic: 'STUDY'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pinned Conversations')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pinned.length,
        itemBuilder: (context, index) {
          final conv = pinned[index];
          return ConversationCard(
            conversation: conv,
            onTap: () => context.push('${RouteNames.aiMentorConversation}?id=${conv.id}'),
          );
        },
      ),
    );
  }
}
