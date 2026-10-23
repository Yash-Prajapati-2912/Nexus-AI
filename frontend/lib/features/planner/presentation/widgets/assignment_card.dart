import 'package:flutter/material.dart';
import '../../../../shared/design_system/widgets/cards/app_card.dart';
import '../../domain/entities/assignment_entity.dart';

class AssignmentCard extends StatelessWidget {
  final AssignmentEntity assignment;

  const AssignmentCard({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(assignment.subject, style: Theme.of(context).textTheme.labelSmall),
              Text('Due: ${assignment.dueDate.day}/${assignment.dueDate.month}', style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
          const SizedBox(height: 4),
          Text(assignment.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: assignment.progressPercentage),
        ],
      ),
    );
  }
}
