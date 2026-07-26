import 'package:flutter/material.dart';
import '../../domain/entities/achievement.dart';
import '../widgets/achievement_card.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  final List<Achievement> _achievements = const [
    Achievement(id: 'ac1', title: '14-Day Study Streak', description: 'Maintained 14 consecutive study sessions', badgeUrl: '', category: 'STREAK', isUnlocked: true, progress: 14, maxProgress: 14),
    Achievement(id: 'ac2', title: 'Finance Master', description: 'Saved over \$1,000 using AI Budget advice', badgeUrl: '', category: 'FINANCE', isUnlocked: true, progress: 1450, maxProgress: 1000),
    Achievement(id: 'ac3', title: 'Task Ninja', description: 'Completed 50 Smart Planner study tasks', badgeUrl: '', category: 'PRODUCTIVITY', isUnlocked: true, progress: 64, maxProgress: 50),
    Achievement(id: 'ac4', title: 'AI Scholar', description: 'Engaged in 200 AI Mentor coaching sessions', badgeUrl: '', category: 'AI_MENTOR', isUnlocked: false, progress: 142, maxProgress: 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements & Badges')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _achievements.length,
        itemBuilder: (context, index) {
          return AchievementCard(achievement: _achievements[index]);
        },
      ),
    );
  }
}
