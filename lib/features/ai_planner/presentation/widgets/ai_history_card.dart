import 'package:flutter/material.dart';
import '../../domain/entities/ai_history_item.dart';

class AIHistoryCard extends StatelessWidget {
  final AIHistoryItem item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onBookmarkToggle;

  const AIHistoryCard({
    super.key,
    required this.item,
    this.onTap,
    this.onDelete,
    this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.actionType.replaceAll('_', ' '),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        _formatDate(item.createdAt),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (onBookmarkToggle != null)
                        IconButton(
                          icon: Icon(
                            item.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                            color: item.isBookmarked ? theme.colorScheme.primary : null,
                            size: 18,
                          ),
                          onPressed: onBookmarkToggle,
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
                          onPressed: onDelete,
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                item.prompt,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.responseSummary,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
