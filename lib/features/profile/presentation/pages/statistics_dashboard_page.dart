import 'package:flutter/material.dart';
import '../widgets/statistics_card.dart';

class StatisticsDashboardPage extends StatelessWidget {
  const StatisticsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overall Performance Summary', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: const [
                StatisticsCard(label: 'Study Streak', value: '14 Days', icon: Icons.local_fire_department_rounded, color: Colors.orangeAccent),
                StatisticsCard(label: 'Total Study Hours', value: '128.5 hrs', icon: Icons.schedule_rounded, color: Colors.blueAccent),
                StatisticsCard(label: 'Productivity Score', value: '88/100', icon: Icons.bolt_rounded, color: Color(0xFF10B981)),
                StatisticsCard(label: 'Tasks Completed', value: '64 Tasks', icon: Icons.check_circle_rounded, color: Colors.purpleAccent),
                StatisticsCard(label: 'Total Savings', value: '\$1,450.75', icon: Icons.savings_rounded, color: Color(0xFF10B981)),
                StatisticsCard(label: 'AI Mentor Queries', value: '142 Prompt', icon: Icons.auto_awesome, color: Color(0xFF6366F1)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
