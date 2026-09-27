import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/branding/nexus_logo.dart';
import '../../domain/entities/chat_message.dart';
import 'markdown_renderer.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onBookmark;
  final VoidCallback? onRetry;

  const ChatBubble({
    super.key,
    required this.message,
    this.onBookmark,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUser = message.sender.toUpperCase() == 'USER';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width > 768
              ? 700
              : MediaQuery.of(context).size.width * 0.85,
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Sender Avatar & Name Header
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isUser) ...[
                    NexusLogoMark(
                      size: 16,
                      isDark: Theme.of(context).brightness == Brightness.dark,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Nexus AI',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF818CF8),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ] else ...[
                    const Text(
                      'You',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.person_rounded, size: 14, color: Colors.grey),
                  ],
                ],
              ),
            ),

            // Message Bubble Container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isUser
                    ? (isDark ? const Color(0xFF4338CA) : Colors.indigo.shade600)
                    : (isDark ? const Color(0xFF1E293B) : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                border: isUser
                    ? null
                    : Border.all(
                        color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08),
                        width: 1,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: isUser
                  ? Text(
                      message.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.45,
                        fontFamily: 'Poppins',
                      ),
                    )
                  : MarkdownRenderer(text: message.content),
            ),

            // Section 6: AI Response Action Bar (Copy, Retry, Bookmark)
            if (!isUser)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    // Copy Action
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: message.content));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied response to clipboard'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.copy_rounded, size: 13, color: isDark ? Colors.white54 : Colors.black45),
                            const SizedBox(width: 4),
                            Text(
                              'Copy',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.white54 : Colors.black45,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Retry Action
                    if (onRetry != null)
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: onRetry,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh_rounded, size: 13, color: isDark ? Colors.white54 : Colors.black45),
                              const SizedBox(width: 4),
                              Text(
                                'Retry',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? Colors.white54 : Colors.black45,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Bookmark Action
                    if (onBookmark != null)
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: onBookmark,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                message.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                size: 13,
                                color: message.isBookmarked ? Colors.amber : (isDark ? Colors.white54 : Colors.black45),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                message.isBookmarked ? 'Saved' : 'Save',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: message.isBookmarked ? Colors.amber : (isDark ? Colors.white54 : Colors.black45),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
