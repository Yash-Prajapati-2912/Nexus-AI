import 'package:flutter/material.dart';

class ConfidenceScoreBadge extends StatelessWidget {
  final double score; // 0.0 to 1.0 or 0 to 100

  const ConfidenceScoreBadge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final normalized = score > 1.0 ? score / 100.0 : score;
    final percentage = (normalized * 100).toInt();

    Color badgeColor;
    if (normalized >= 0.85) {
      badgeColor = const Color(0xFF10B981);
    } else if (normalized >= 0.70) {
      badgeColor = Colors.amber;
    } else {
      badgeColor = Colors.deepOrange;
    }


    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badgeColor.withAlpha(120), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stars_rounded, size: 14, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            '$percentage% AI Confidence',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}
