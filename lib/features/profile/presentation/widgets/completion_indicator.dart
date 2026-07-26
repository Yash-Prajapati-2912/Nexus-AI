import 'package:flutter/material.dart';

class CompletionIndicator extends StatelessWidget {
  final int percentage;

  const CompletionIndicator({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = percentage >= 80 ? const Color(0xFF10B981) : Colors.orangeAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '$percentage% Profile Complete',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
