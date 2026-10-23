import 'package:flutter/material.dart';
import '../../tokens/colors/semantic_colors.dart';

class AiRecommendationChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const AiRecommendationChip({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.auto_awesome_rounded, size: 16, color: SemanticColors.aiAccent),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
