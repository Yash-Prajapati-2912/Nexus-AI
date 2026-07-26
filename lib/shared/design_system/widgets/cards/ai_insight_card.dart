import 'package:flutter/material.dart';
import '../../tokens/colors/semantic_colors.dart';
import 'app_card.dart';

class AiInsightCard extends StatelessWidget {
  final String title;
  final String insight;

  const AiInsightCard({
    super.key,
    required this.title,
    required this.insight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: SemanticColors.aiGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(1),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome_rounded, color: SemanticColors.aiAccent),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(insight, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
