import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/widgets/base_scaffold.dart';
import '../../domain/entities/conversation.dart';
import '../bloc/ai_mentor_bloc.dart';
import '../widgets/conversation_card.dart';

class ConversationHistoryPage extends StatefulWidget {
  const ConversationHistoryPage({super.key});

  @override
  State<ConversationHistoryPage> createState() => _ConversationHistoryPageState();
}

class _ConversationHistoryPageState extends State<ConversationHistoryPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<AIMentorBloc>();
    if (bloc.state is! AIMentorLoadedState) {
      bloc.add(const LoadAIMentorDashboardEvent());
    }
  }

  Future<void> _refresh() async {
    context.read<AIMentorBloc>().add(const LoadAIMentorDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text(
          'Conversation History',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.push_pin_rounded),
            onPressed: () async {
              await context.push(RouteNames.aiMentorPinnedConversations);
              if (mounted) await _refresh();
            },
            tooltip: 'Pinned Conversations',
          ),
        ],
      ),
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
                      'Failed to load conversations',
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
                      onPressed: _refresh,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final List<Conversation> conversations =
              (state is AIMentorLoadedState) ? state.recentConversations : <Conversation>[];

          if (conversations.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chat_bubble_outline_rounded, size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          const Text(
                            'No previous conversations found.',
                            style: TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Poppins'),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await context.push(RouteNames.aiMentorConversation);
                              if (mounted) await _refresh();
                            },
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Start New Conversation'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conv = conversations[index];
                return ConversationCard(
                  conversation: conv,
                  onTap: () async {
                    await context.push('${RouteNames.aiMentorConversation}?id=${conv.id}');
                    if (mounted) await _refresh();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
