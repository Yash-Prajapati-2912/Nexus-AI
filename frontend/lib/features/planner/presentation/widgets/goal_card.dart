import 'package:flutter/material.dart';
import '../../../../shared/design_system/widgets/cards/app_card.dart';
import '../../domain/entities/goal_entity.dart';

class GoalCard extends StatelessWidget {
  final GoalEntity goal;

  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(goal.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(goal.description, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: goal.progressPercentage),
        ],
      ),
    );
  }
}
