import 'package:flutter/material.dart';
import '../../../../shared/design_system/widgets/cards/planner_card.dart';
import '../../domain/entities/planner_summary_entity.dart';

class PlannerSummaryWidget extends StatelessWidget {
  final PlannerSummaryEntity summary;

  const PlannerSummaryWidget({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Smart Planner Summary', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        PlannerCard(
          title: summary.nextAssignmentTitle ?? 'Study Machine Learning Architecture',
          dueTime: 'Due Today at 11:59 PM',
          isCompleted: false,
          onToggle: (val) {},
        ),
      ],
    );
  }
}
