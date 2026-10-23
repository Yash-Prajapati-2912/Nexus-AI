import 'package:flutter/material.dart';

class ConfidenceBadge extends StatelessWidget {
  final double confidenceScore;

  const ConfidenceBadge({super.key, required this.confidenceScore});

  @override
  Widget build(BuildContext context) {
    final pct = (confidenceScore * 100).toInt();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF6366F1).withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, size: 12, color: Color(0xFF6366F1)),
          const SizedBox(width: 4),
          Text(
            '$pct% AI Confidence',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6366F1)),
          ),
        ],
      ),
    );
  }
}
