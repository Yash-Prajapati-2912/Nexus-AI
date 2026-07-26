import 'package:flutter/material.dart';
import '../../domain/entities/milestone_entity.dart';

class MilestoneCard extends StatelessWidget {
  final MilestoneEntity milestone;

  const MilestoneCard({super.key, required this.milestone});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        milestone.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
        color: milestone.isCompleted ? Colors.green : Colors.grey,
      ),
      title: Text(milestone.title),
    );
  }
}
