import 'package:flutter/material.dart';
import '../../domain/entities/conversation.dart';

class ConversationCard extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;
  final VoidCallback? onPin;
  final VoidCallback? onDelete;

  const ConversationCard({
    super.key,
    required this.conversation,
    required this.onTap,
    this.onPin,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(_getTopicIcon(conversation.topic), color: theme.colorScheme.primary, size: 20),
        ),
        title: Text(
          conversation.title,
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          conversation.lastMessageSnippet,
          style: theme.textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (conversation.isPinned)
              const Icon(Icons.push_pin_rounded, color: Colors.amber, size: 16),
            PopupMenuButton<String>(
              onSelected: (val) {
                if (val == 'pin' && onPin != null) onPin!();
                if (val == 'delete' && onDelete != null) onDelete!();
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'pin',
                  child: Text(conversation.isPinned ? 'Unpin' : 'Pin to top'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTopicIcon(String topic) {
    switch (topic.toUpperCase()) {
      case 'STUDY':
        return Icons.menu_book_rounded;
      case 'CAREER':
        return Icons.work_rounded;
      case 'FINANCE':
        return Icons.account_balance_wallet_rounded;
      case 'PRODUCTIVITY':
        return Icons.bolt_rounded;
      default:
        return Icons.chat_bubble_outline_rounded;
    }
  }
}
