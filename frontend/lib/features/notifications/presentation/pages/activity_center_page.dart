import 'package:flutter/material.dart';
import '../../domain/entities/activity_item.dart';
import '../widgets/activity_card.dart';
import '../widgets/timeline_card.dart';

class ActivityCenterPage extends StatelessWidget {
  ActivityCenterPage({super.key});

  final List<ActivityItem> _activities = [
    ActivityItem(id: 'a1', userId: 'u1', action: 'COMPLETED_TASK', module: 'PLANNER', description: 'Completed CS101 Lecture Notes Study Task', timestamp: DateTime.now(), icon: 'check_circle'),
    ActivityItem(id: 'a2', userId: 'u1', action: 'LOGGED_EXPENSE', module: 'FINANCE', description: 'Added \$14.50 expense for Textbooks', timestamp: DateTime.now(), icon: 'receipt'),
    ActivityItem(id: 'a3', userId: 'u1', action: 'AI_COACHING', module: 'MENTOR', description: 'Had 10-minute Career Guidance Chat', timestamp: DateTime.now(), icon: 'auto_awesome'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity Center')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TimelineCard(
            dateTitle: 'Today',
            children: _activities.map((act) => ActivityCard(activity: act)).toList(),
          ),
        ],
      ),
    );
  }
}
