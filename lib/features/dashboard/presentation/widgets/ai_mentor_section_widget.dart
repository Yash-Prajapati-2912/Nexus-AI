import 'package:flutter/material.dart';
import '../../../../shared/design_system/widgets/cards/ai_insight_card.dart';
import '../../domain/entities/ai_insight_entity.dart';

class AiMentorSectionWidget extends StatelessWidget {
  final AiInsightEntity insight;

  const AiMentorSectionWidget({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('AI Mentor Guidance', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        AiInsightCard(
          title: insight.title,
          insight: insight.insight,
        ),
      ],
    );
  }
}
