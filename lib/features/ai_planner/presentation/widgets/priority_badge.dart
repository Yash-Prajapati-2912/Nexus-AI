import 'package:flutter/material.dart';

class PriorityBadge extends StatelessWidget {
  final String priority;

  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label = priority.toUpperCase();

    switch (label) {
      case 'CRITICAL':
        bg = Colors.red.shade900.withAlpha(50);
        fg = Colors.redAccent;
        break;
      case 'HIGH':
        bg = Colors.orange.shade900.withAlpha(50);
        fg = Colors.orangeAccent;
        break;
      case 'MEDIUM':
        bg = Colors.blue.shade900.withAlpha(50);
        fg = Colors.lightBlueAccent;
        break;
      case 'LOW':
      default:
        bg = Colors.green.shade900.withAlpha(50);
        fg = Colors.lightGreenAccent;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: fg.withAlpha(100), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: fg,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
