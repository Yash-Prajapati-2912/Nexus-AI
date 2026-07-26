import 'package:flutter/material.dart';
import '../../../../shared/design_system/widgets/cards/stat_card.dart';
import '../../domain/entities/planner_summary_entity.dart';

class TodayOverviewWidget extends StatelessWidget {
  final PlannerSummaryEntity summary;

  const TodayOverviewWidget({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Today's Overview", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'Tasks Today',
                value: '${summary.completedTasksCount}/${summary.todayTasksCount}',
                icon: Icons.check_circle_outline_rounded,
                subtitle: '${(summary.studyProgressPercentage * 100).toInt()}% Done',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                label: 'Priority Tasks',
                value: '${summary.priorityTasksCount}',
                icon: Icons.priority_high_rounded,
                subtitle: summary.nextAssignmentTitle ?? 'No urgent deadlines',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
