import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/conversation.dart';
import '../widgets/conversation_card.dart';

class ConversationHistoryPage extends StatelessWidget {
  const ConversationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Conversation> conversations = [
      Conversation(id: 'c1', title: 'Midterm Prep Strategy', createdAt: DateTime.now(), updatedAt: DateTime.now(), messageCount: 12, lastMessageSnippet: 'Focus on trees & graphs', topic: 'STUDY'),
      Conversation(id: 'c2', title: 'Resume Skill Gap Analysis', createdAt: DateTime.now().subtract(const Duration(days: 2)), updatedAt: DateTime.now().subtract(const Duration(days: 2)), messageCount: 6, lastMessageSnippet: 'Add Docker & CI/CD section', topic: 'CAREER'),
      Conversation(id: 'c3', title: 'Monthly Budgeting Strategy', createdAt: DateTime.now().subtract(const Duration(days: 5)), updatedAt: DateTime.now().subtract(const Duration(days: 5)), messageCount: 4, lastMessageSnippet: 'Dining out reduced by 15%', topic: 'FINANCE'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation History'),
        actions: [
          IconButton(icon: const Icon(Icons.push_pin_rounded), onPressed: () => context.push(RouteNames.aiMentorPinnedConversations)),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conv = conversations[index];
          return ConversationCard(
            conversation: conv,
            onTap: () => context.push('${RouteNames.aiMentorConversation}?id=${conv.id}'),
          );
        },
      ),
    );
  }
}
