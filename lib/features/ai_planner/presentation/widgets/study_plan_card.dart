import 'package:flutter/material.dart';
import '../../domain/entities/study_plan.dart';
import 'confidence_score_badge.dart';

class StudyPlanCard extends StatelessWidget {
  final StudyPlan plan;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;

  const StudyPlanCard({
    super.key,
    required this.plan,
    this.onTap,
    this.onSave,
    this.onDelete,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      plan.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ConfidenceScoreBadge(score: plan.confidenceScore),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                plan.summary,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.format_list_bulleted_rounded,
                      size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    '${plan.actionItems.length} Steps',
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.calendar_today_rounded,
                      size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    plan.timeframe.toUpperCase(),
                    style: theme.textTheme.labelMedium,
                  ),
                  const Spacer(),
                  if (onShare != null)
                    IconButton(
                      icon: const Icon(Icons.share_outlined, size: 20),
                      onPressed: onShare,
                      tooltip: 'Share Plan',
                    ),
                  if (onSave != null)
                    IconButton(
                      icon: Icon(
                        plan.isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                        color: plan.isSaved ? theme.colorScheme.primary : null,
                        size: 20,
                      ),
                      onPressed: onSave,
                      tooltip: 'Save Plan',
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.redAccent),
                      onPressed: onDelete,
                      tooltip: 'Delete Plan',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
