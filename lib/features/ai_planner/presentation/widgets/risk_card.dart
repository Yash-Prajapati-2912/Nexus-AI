import 'package:flutter/material.dart';
import '../../domain/entities/deadline_risk.dart';
import 'priority_badge.dart';

class RiskCard extends StatelessWidget {
  final CriticalDeadlineItem deadlineItem;

  const RiskCard({super.key, required this.deadlineItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = (deadlineItem.lateProbability * 100).toInt();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: deadlineItem.riskLevel == 'CRITICAL'
              ? Colors.red.withAlpha(150)
              : Colors.orange.withAlpha(100),
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: deadlineItem.riskLevel == 'CRITICAL'
                    ? Colors.red.shade900.withAlpha(40)
                    : Colors.orange.shade900.withAlpha(40),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: deadlineItem.riskLevel == 'CRITICAL'
                    ? Colors.redAccent
                    : Colors.orangeAccent,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          deadlineItem.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PriorityBadge(priority: deadlineItem.riskLevel),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deadlineItem.warningMessage,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 14, color: theme.colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        'Due: ${_formatDate(deadlineItem.dueDate)}',
                        style: theme.textTheme.labelSmall,
                      ),
                      const Spacer(),
                      Text(
                        '$percentage% Late Risk',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: deadlineItem.riskLevel == 'CRITICAL'
                              ? Colors.redAccent
                              : Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
