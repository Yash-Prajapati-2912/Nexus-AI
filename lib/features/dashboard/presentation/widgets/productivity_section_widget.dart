import 'package:flutter/material.dart';
import '../../../../shared/design_system/widgets/cards/stat_card.dart';
import '../../domain/entities/productivity_stats_entity.dart';

class ProductivitySectionWidget extends StatelessWidget {
  final ProductivityStatsEntity stats;

  const ProductivitySectionWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Productivity & Streak', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'Study Streak',
                value: '${stats.streakDays} Days 🔥',
                icon: Icons.local_fire_department_rounded,
                subtitle: 'Daily Target Met',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                label: 'Study Hours',
                value: '${stats.studyHoursThisWeek} hrs',
                icon: Icons.timer_rounded,
                subtitle: 'This Week',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
