import 'package:flutter/material.dart';
import 'markdown_viewer.dart';
import 'typing_indicator.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class MiniAIChatPanel extends StatefulWidget {
  const MiniAIChatPanel({super.key});

  @override
  State<MiniAIChatPanel> createState() => _MiniAIChatPanelState();
}

class _MiniAIChatPanelState extends State<MiniAIChatPanel> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hello! I am your AI Smart Planner Assistant. How can I optimize your schedule today?',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];
  bool _isGenerating = false;

  final List<String> _suggestedPrompts = [
    'How should I prioritize my upcoming exams?',
    'Suggest a 2-hour study plan for Computer Science.',
    'How can I balance research and assignments this week?',
    'What breaks should I take during heavy study sessions?',
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isGenerating = true;
    });

    _controller.clear();

    // Simulate streaming AI Response
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _messages.add(ChatMessage(
            text: 'Based on your active workload and past study habits, here is my recommendation:\n\n'
                '1. **Focus Session**: 90 mins on urgent deadlines.\n'
                '2. **Pomodoro Break**: 15 mins active stretch.\n'
                '3. **Review**: 30 mins light reading.\n\n'
                'Would you like me to insert this directly into your planner calendar?',
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 480,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.auto_awesome_rounded, color: theme.colorScheme.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nexus AI Planner Assistant',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Streaming AI Reasoning Ready',
                        style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF10B981)),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Suggested Prompts horizontal scroll
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: _suggestedPrompts.length,
              itemBuilder: (context, index) {
                final prompt = _suggestedPrompts[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(
                      prompt,
                      style: const TextStyle(fontSize: 11),
                    ),
                    onPressed: () => _sendMessage(prompt),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Message List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length + (_isGenerating ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isGenerating) {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: TypingIndicator(),
                    ),
                  );
                }
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    margin: const EdgeInsets.symmetric(vertical: 4),

                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest.withAlpha(150),
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: msg.isUser ? Radius.zero : const Radius.circular(16),
                        bottomLeft: !msg.isUser ? Radius.zero : const Radius.circular(16),
                      ),
                    ),
                    child: msg.isUser
                        ? Text(
                            msg.text,
                            style: TextStyle(color: theme.colorScheme.onPrimary),
                          )
                        : MarkdownViewer(text: msg.text),
                  ),
                );
              },
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: theme.colorScheme.surface,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration(
                      hintText: 'Ask AI Planner...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.send_rounded, size: 20),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
