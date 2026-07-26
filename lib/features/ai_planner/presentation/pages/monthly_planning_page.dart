import 'package:flutter/material.dart';

class MonthlyPlanningPage extends StatelessWidget {
  const MonthlyPlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Planning'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withAlpha(120),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly Academic Blueprint',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '3 Major Exams & 4 Assignment Milestones projected for July 2026.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Major Academic Milestones',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _MilestoneItem(
              title: 'Midterm Exam: Data Structures',
              date: 'July 28, 2026',
              risk: 'HIGH',
              color: Colors.redAccent,
            ),
            _MilestoneItem(
              title: 'Linear Algebra Term Paper Submission',
              date: 'August 02, 2026',
              risk: 'MEDIUM',
              color: Colors.orangeAccent,
            ),
            _MilestoneItem(
              title: 'Software Design Presentation',
              date: 'August 10, 2026',
              risk: 'LOW',
              color: const Color(0xFF10B981),
            ),

          ],
        ),
      ),
    );
  }
}

class _MilestoneItem extends StatelessWidget {
  final String title;
  final String date;
  final String risk;
  final Color color;

  const _MilestoneItem({
    required this.title,
    required this.date,
    required this.risk,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(Icons.flag_rounded, color: color, size: 24),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Target: $date'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(40),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$risk RISK',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ),
    );
  }
}
