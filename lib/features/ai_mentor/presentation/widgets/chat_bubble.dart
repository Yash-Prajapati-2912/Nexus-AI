import 'package:flutter/material.dart';
import '../../domain/entities/chat_message.dart';
import 'markdown_renderer.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onBookmark;

  const ChatBubble({super.key, required this.message, this.onBookmark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.sender.toUpperCase() == 'USER';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isUser ? Icons.person_rounded : Icons.auto_awesome,
                      size: 14,
                      color: isUser ? Colors.white70 : theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isUser ? 'You' : 'AI Mentor',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isUser ? Colors.white70 : theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                if (!isUser && onBookmark != null)
                  IconButton(
                    icon: Icon(
                      message.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: onBookmark,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 6),
            isUser
                ? Text(message.content, style: const TextStyle(color: Colors.white, fontSize: 14))
                : MarkdownRenderer(text: message.content),
          ],
        ),
      ),
    );
  }
}
