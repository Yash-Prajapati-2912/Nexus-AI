import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/conversation.dart';
import '../bloc/ai_mentor_bloc.dart';
import '../bloc/conversation_bloc.dart';
import '../../../../shared/branding/nexus_logo.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/typing_indicator.dart';

class ConversationScreen extends StatefulWidget {
  final String? conversationId;
  final String? initialPrompt;
  final String? topic;

  const ConversationScreen({
    super.key,
    this.conversationId,
    this.initialPrompt,
    this.topic,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isVoiceRecording = false;

  @override
  void initState() {
    super.initState();
    final convId = widget.conversationId ?? 'c_new';
    context.read<ConversationBloc>().add(LoadConversationEvent(convId));

    if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(widget.initialPrompt!);
      });
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final state = context.read<ConversationBloc>().state;
    if (state is ConversationLoadedState && state.isSending) return;

    final convId = widget.conversationId ?? 'c_new';

    context.read<ConversationBloc>().add(SendChatMessageEvent(
          conversationId: convId,
          content: text.trim(),
          topic: widget.topic,
        ));

    _inputController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                NexusLogoMark(
                  size: 20,
                  isDark: isDark,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.topic != null ? '${widget.topic} Agent' : 'Nexus AI Agent',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
            const Text(
              'Online • Context-Aware',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10, color: Color(0xFF34D399), fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => context.push(RouteNames.aiMentorHistory),
            tooltip: 'History',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => context.push(RouteNames.aiMentorConversationDetails),
            tooltip: 'Details',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;

          if (isDesktop) {
            return Row(
              children: [
                // Desktop History Sidebar
                Container(
                  width: 280,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade50,
                    border: Border(right: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
                  ),
                  child: _buildDesktopSidebar(context, isDark),
                ),

                // Desktop Chat Workspace Centered
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: _buildChatColumn(context, isDark),
                    ),
                  ),
                ),
              ],
            );
          }

          // Mobile / Tablet full width chat
          return _buildChatColumn(context, isDark);
        },
      ),
    );
  }

  Widget _buildChatColumn(BuildContext context, bool isDark) {
    return Column(
      children: [
        // Message History Area
        Expanded(
          child: BlocConsumer<ConversationBloc, ConversationState>(
            listener: (context, state) {
              if (state is ConversationLoadedState) {
                _scrollToBottom();
              }
            },
            builder: (context, state) {
              if (state is ConversationLoadingState) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.indigoAccent),
                      SizedBox(height: 12),
                      Text('Loading conversation...', style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins')),
                    ],
                  ),
                );
              }

              final messages = (state is ConversationLoadedState)
                  ? state.messages
                  : [
                      ChatMessage(
                        id: 'm1',
                        conversationId: 'c1',
                        sender: 'AI',
                        content: 'Hello! I am your **Nexus AI Agent**. I can analyze your tasks, track your spending, or help you structure your study schedule. What would you like to focus on today?',
                        createdAt: DateTime.now(),
                      ),
                    ];

              final isSending = (state is ConversationLoadedState) ? state.isSending : false;

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: messages.length + (isSending ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == messages.length && isSending) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          NexusLogoMark(
                            size: 18,
                            isDark: isDark,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Nexus AI is analyzing your data...',
                            style: TextStyle(fontSize: 12, color: Colors.indigoAccent, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                          ),
                          const SizedBox(width: 8),
                          const TypingIndicator(),
                        ],
                      ),
                    );
                  }
                  return ChatBubble(
                    message: messages[index],
                    onRetry: () => _sendMessage(messages[index].content),
                  );
                },
              );
            },
          ),
        ),

        if (_isVoiceRecording)
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.redAccent.withValues(alpha: 0.15),
            child: const Row(
              children: [
                Icon(Icons.mic_rounded, color: Colors.redAccent),
                SizedBox(width: 8),
                Text(
                  'Recording voice prompt... Tap mic to stop & send',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 13, fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),

        // Section 7: Premium Input Composer
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            border: Border(
              top: BorderSide(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file_rounded, color: Colors.grey),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Attachment selector ready')),
                    );
                  },
                  tooltip: 'Add Attachment',
                ),
                IconButton(
                  icon: Icon(_isVoiceRecording ? Icons.stop_circle_rounded : Icons.mic_rounded),
                  color: _isVoiceRecording ? Colors.redAccent : Colors.indigoAccent,
                  onPressed: () => setState(() => _isVoiceRecording = !_isVoiceRecording),
                  tooltip: 'Voice Prompt',
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.black12,
                      ),
                    ),
                    child: TextField(
                      controller: _inputController,
                      maxLines: 4,
                      minLines: 1,
                      decoration: const InputDecoration(
                        hintText: 'Message Nexus AI Agent...',
                        hintStyle: TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.send_rounded, size: 18),
                  onPressed: () => _sendMessage(_inputController.text),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                  ),
                  tooltip: 'Send Prompt',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopSidebar(BuildContext context, bool isDark) {
    return BlocBuilder<AIMentorBloc, AIMentorState>(
      builder: (context, state) {
        final recentConvs = (state is AIMentorLoadedState) ? state.recentConversations : <Conversation>[];

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.push(RouteNames.aiMentorConversation),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('New Conversation', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Recent Chats',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white54 : Colors.black54,
                  letterSpacing: 0.5,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: recentConvs.isEmpty
                    ? const Center(child: Text('No previous chats', style: TextStyle(fontSize: 12, color: Colors.grey)))
                    : ListView.builder(
                        itemCount: recentConvs.length,
                        itemBuilder: (context, index) {
                          final c = recentConvs[index];
                          return ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                            leading: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Colors.indigoAccent),
                            title: Text(
                              c.title,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => context.push('${RouteNames.aiMentorConversation}?id=${c.id}'),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
