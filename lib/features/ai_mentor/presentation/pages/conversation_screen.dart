import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/chat_message.dart';
import '../bloc/conversation_bloc.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.topic != null ? '${widget.topic} Mentor' : 'AI Mentor',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text('Online • Context-Aware', style: TextStyle(fontSize: 11, color: Colors.greenAccent)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => context.push(RouteNames.aiMentorConversationDetails),
            tooltip: 'Details',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ConversationBloc, ConversationState>(
              listener: (context, state) {
                if (state is ConversationLoadedState) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state is ConversationLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = (state is ConversationLoadedState)
                    ? state.messages
                    : [
                        ChatMessage(
                          id: 'm1',
                          conversationId: 'c1',
                          sender: 'AI',
                          content: 'Hello! I am your **AI Mentor**. How can I help you today with your studies, career goals, or daily schedule?',
                          createdAt: DateTime.now(),
                        ),
                      ];

                final isSending = (state is ConversationLoadedState) ? state.isSending : false;

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length + (isSending ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length && isSending) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.auto_awesome, color: Color(0xFF6366F1), size: 18),
                            const SizedBox(width: 8),
                            Text('AI Mentor is thinking...', style: theme.textTheme.bodySmall),
                            const SizedBox(width: 8),
                            const TypingIndicator(),
                          ],
                        ),
                      );
                    }
                    return ChatBubble(message: messages[index]);
                  },
                );
              },
            ),
          ),

          if (_isVoiceRecording)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.redAccent.withAlpha(30),
              child: const Row(
                children: [
                  Icon(Icons.mic_rounded, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Text('Recording voice message... Tap mic to send', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                ],
              ),
            ),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4, offset: const Offset(0, -2)),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file_rounded),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Attachment picker opened')),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(_isVoiceRecording ? Icons.stop_circle_rounded : Icons.mic_rounded),
                  color: _isVoiceRecording ? Colors.redAccent : theme.colorScheme.primary,
                  onPressed: () => setState(() => _isVoiceRecording = !_isVoiceRecording),
                ),
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: const InputDecoration(
                      hintText: 'Ask AI Mentor...',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.send_rounded),
                  onPressed: () => _sendMessage(_inputController.text),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
