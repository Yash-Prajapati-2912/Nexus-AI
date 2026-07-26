import 'package:flutter/material.dart';

class GoalsOverviewPage extends StatelessWidget {
  const GoalsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Goals Overview')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _GoalTile(title: 'Maintain 3.8+ CGPA', category: 'Academic', progress: 0.95),
          _GoalTile(title: 'Save \$2,000 for Emergency Fund', category: 'Financial', progress: 0.72),
          _GoalTile(title: 'Complete Full-Stack AI Coursework', category: 'Career', progress: 0.85),
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  final String title;
  final String category;
  final double progress;

  const _GoalTile({required this.title, required this.category, required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = (progress * 100).toInt();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                Text('$pct%', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
              ],
            ),
            const SizedBox(height: 4),
            Text(category, style: theme.textTheme.labelSmall),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
