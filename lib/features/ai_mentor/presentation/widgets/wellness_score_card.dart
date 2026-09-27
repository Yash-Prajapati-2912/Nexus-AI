import 'package:flutter/material.dart';
import '../../../../shared/design_system/widgets/cards/app_card.dart';
import '../../domain/entities/student_wellness.dart';

class WellnessScoreCard extends StatelessWidget {
  final StudentWellness wellness;

  const WellnessScoreCard({super.key, required this.wellness});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = wellness.overallWellnessScore;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.favorite_rounded, color: Colors.pinkAccent, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Productivity Wellness Score',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('$score/100', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
              ),
            ],
          ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _Bar(label: 'Academic', score: wellness.academicPerformanceScore)),
                const SizedBox(width: 8),
                Expanded(child: _Bar(label: 'Finance', score: wellness.financialWellnessScore)),
                const SizedBox(width: 8),
                Expanded(child: _Bar(label: 'Productivity', score: wellness.productivityScore)),
                const SizedBox(width: 8),
                Expanded(child: _Bar(label: 'Career', score: wellness.careerReadinessScore)),
              ],
            ),
          ],
        ),
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final int score;

  const _Bar({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(label, style: theme.textTheme.labelSmall),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100.0,
            minHeight: 6,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
          ),
        ),
        const SizedBox(height: 2),
        Text('$score', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
