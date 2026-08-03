import 'package:flutter/material.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../../domain/entities/chat_message.dart';
import 'markdown_renderer.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onBookmark;

  const ChatBubble({super.key, required this.message, this.onBookmark});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUser = message.sender.toUpperCase() == 'USER';

    final userBg = isDark
        ? DesignColors.primaryDark
        : DesignColors.primaryLight;

    final aiBg = isDark
        ? DesignColors.glassSurfaceDark
        : DesignColors.glassSurfaceLight;

    final aiBorder = isDark
        ? DesignColors.glassBorderDark
        : DesignColors.glassBorderLight;

    final aiTitleColor = isDark
        ? DesignColors.primaryDark
        : DesignColors.primaryLight;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUser ? userBg : aiBg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
          border: isUser ? null : Border.all(color: aiBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.2) : Colors.indigo.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
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
                      isUser ? Icons.person_rounded : Icons.auto_awesome_rounded,
                      size: 15,
                      color: isUser ? Colors.white.withOpacity(0.9) : aiTitleColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isUser ? 'You' : 'AI Mentor',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isUser ? Colors.white.withOpacity(0.9) : aiTitleColor,
                      ),
                    ),
                  ],
                ),
                if (!isUser && onBookmark != null)
                  IconButton(
                    icon: Icon(
                      message.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      size: 16,
                      color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                    ),
                    onPressed: onBookmark,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            isUser
                ? Text(
                    message.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      height: 1.4,
                    ),
                  )
                : MarkdownRenderer(text: message.content),
          ],
        ),
      ),
    );
  }
}

