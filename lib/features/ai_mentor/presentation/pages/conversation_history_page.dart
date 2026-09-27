import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/widgets/base_scaffold.dart';
import '../../domain/entities/conversation.dart';
import '../bloc/ai_mentor_bloc.dart';
import '../widgets/conversation_card.dart';

class ConversationHistoryPage extends StatelessWidget {
  const ConversationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Conversation History', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
        actions: [
          IconButton(
            icon: const Icon(Icons.push_pin_rounded),
            onPressed: () => context.push(RouteNames.aiMentorPinnedConversations),
            tooltip: 'Pinned Conversations',
          ),
        ],
      ),
      body: BlocBuilder<AIMentorBloc, AIMentorState>(
        builder: (context, state) {
          final List<Conversation> conversations = (state is AIMentorLoadedState)
              ? state.recentConversations
              : [
                  Conversation(id: 'c1', title: 'Midterm Prep Strategy', createdAt: DateTime.now(), updatedAt: DateTime.now(), messageCount: 12, lastMessageSnippet: 'Focus on trees & graphs', topic: 'STUDY'),
                  Conversation(id: 'c2', title: 'Resume Skill Gap Analysis', createdAt: DateTime.now().subtract(const Duration(days: 2)), updatedAt: DateTime.now().subtract(const Duration(days: 2)), messageCount: 6, lastMessageSnippet: 'Add Docker & CI/CD section', topic: 'CAREER'),
                  Conversation(id: 'c3', title: 'Monthly Budgeting Strategy', createdAt: DateTime.now().subtract(const Duration(days: 5)), updatedAt: DateTime.now().subtract(const Duration(days: 5)), messageCount: 4, lastMessageSnippet: 'Dining out reduced by 15%', topic: 'FINANCE'),
                ];

          if (conversations.isEmpty) {
            return const Center(
              child: Text('No previous conversations found.', style: TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Poppins')),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conv = conversations[index];
              return ConversationCard(
                conversation: conv,
                onTap: () => context.push('${RouteNames.aiMentorConversation}?id=${conv.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
