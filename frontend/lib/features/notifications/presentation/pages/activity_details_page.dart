import 'package:flutter/material.dart';

class ActivityDetailsPage extends StatelessWidget {
  const ActivityDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Activity Details')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Action: COMPLETED_STUDY_SESSION', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Module: Smart Planner', style: theme.textTheme.labelMedium),
            const SizedBox(height: 16),
            const Text('Description: Completed 45-minute Pomodoro session on Algorithms.'),
            const Spacer(),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Back to Activity Center')),
          ],
        ),
      ),
    );
  }
}
