import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../di/injection_container.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/i_ai_mentor_repository.dart';
import '../bloc/ai_mentor_bloc.dart';
import '../widgets/conversation_card.dart';

class PinnedConversationsPage extends StatelessWidget {
  const PinnedConversationsPage({super.key});

  Future<void> _unpinConversation(BuildContext context, Conversation conv) async {
    try {
      final repo = getIt<IAIMentorRepository>();
      final result = await repo.updateConversation(conv.id, isPinned: false);
      if (!context.mounted) return;

      result.fold(
        (failure) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to unpin conversation: ${failure.message}'),
            backgroundColor: Colors.redAccent,
          ),
        ),
        (_) {
          context.read<AIMentorBloc>().add(const LoadAIMentorDashboardEvent());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Conversation unpinned.'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, Conversation conv) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Conversation?'),
        content: Text('Are you sure you want to delete "${conv.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final repo = getIt<IAIMentorRepository>();
        final result = await repo.deleteConversation(conv.id);
        if (!context.mounted) return;

        result.fold(
          (failure) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete conversation: ${failure.message}'),
              backgroundColor: Colors.redAccent,
            ),
          ),
          (_) {
            context.read<AIMentorBloc>().add(const LoadAIMentorDashboardEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Conversation deleted successfully.'),
                backgroundColor: Color(0xFF10B981),
              ),
            );
          },
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pinned Conversations')),
      body: BlocBuilder<AIMentorBloc, AIMentorState>(
        builder: (context, state) {
          if (state is AIMentorLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AIMentorFailureState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    const Text(
                      'Failed to load pinned conversations',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<AIMentorBloc>().add(const LoadAIMentorDashboardEvent()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final List<Conversation> pinned = (state is AIMentorLoadedState)
              ? state.pinnedConversations
              : <Conversation>[];

          if (pinned.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.push_pin_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'No Pinned Conversations',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Pin important mentor conversations to access them quickly here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pinned.length,
            itemBuilder: (context, index) {
              final conv = pinned[index];
              return ConversationCard(
                conversation: conv,
                onTap: () async {
                  await context.push('${RouteNames.aiMentorConversation}?id=${conv.id}');
                  if (context.mounted) {
                    context.read<AIMentorBloc>().add(const LoadAIMentorDashboardEvent());
                  }
                },
                onPin: () => _unpinConversation(context, conv),
                onDelete: () => _confirmDelete(context, conv),
              );
            },
          );
        },
      ),
    );
  }
}
