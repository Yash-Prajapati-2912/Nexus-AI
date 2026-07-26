import 'package:flutter/material.dart';

class ProfileCompletionPage extends StatelessWidget {
  const ProfileCompletionPage({super.key});

  final List<Map<String, dynamic>> _checklist = const [
    {'title': 'Add Display Name & Avatar', 'completed': true},
    {'title': 'Fill Academic Info & Degree', 'completed': true},
    {'title': 'Set Learning Style & AI Tone', 'completed': true},
    {'title': 'Link at least 1 SSO Account', 'completed': true},
    {'title': 'Set Primary Career Goal', 'completed': false},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Completion')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: const Color(0xFF6366F1).withAlpha(30),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.verified_rounded, color: Color(0xFF6366F1), size: 36),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Profile Completion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('90% Completed (4 of 5 Tasks)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6366F1))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Completion Checklist', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._checklist.map((item) {
            final isDone = item['completed'] == true;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Icon(
                  isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: isDone ? const Color(0xFF10B981) : Colors.grey,
                ),
                title: Text(
                  item['title'] as String,
                  style: TextStyle(fontWeight: isDone ? FontWeight.normal : FontWeight.bold),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
