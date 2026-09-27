import 'package:flutter/material.dart';
import '../widgets/weekly_heatmap_widget.dart';

class WeeklyPlanningPage extends StatelessWidget {
  const WeeklyPlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Planning'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WeeklyHeatmapWidget(
              heatmapData: {'Mon': 3, 'Tue': 4, 'Wed': 2, 'Thu': 4, 'Fri': 2, 'Sat': 1, 'Sun': 1},
            ),
            const SizedBox(height: 24),
            Text(
              'AI Time-Blocked Schedule',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const _DayScheduleCard(day: 'Monday', subject: 'Computer Science', hours: '3.5 hrs', tasks: 3),
            const _DayScheduleCard(day: 'Tuesday', subject: 'Linear Algebra', hours: '4.0 hrs', tasks: 4),
            const _DayScheduleCard(day: 'Wednesday', subject: 'Physics Lab', hours: '2.0 hrs', tasks: 2),
            const _DayScheduleCard(day: 'Thursday', subject: 'Algorithms & AI', hours: '4.5 hrs', tasks: 5),
            const _DayScheduleCard(day: 'Friday', subject: 'Ethics & Research', hours: '2.5 hrs', tasks: 2),
          ],
        ),
      ),
    );
  }
}

class _DayScheduleCard extends StatelessWidget {
  final String day;
  final String subject;
  final String hours;
  final int tasks;

  const _DayScheduleCard({
    required this.day,
    required this.subject,
    required this.hours,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(Icons.calendar_today_rounded, color: theme.colorScheme.primary, size: 20),
        ),
        title: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$subject • $tasks Tasks'),
        trailing: Text(
          hours,
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}
