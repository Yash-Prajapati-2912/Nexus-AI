import 'package:flutter/material.dart';

class PriorityBadge extends StatelessWidget {
  final String priority;

  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    Color col;
    switch (priority.toUpperCase()) {
      case 'HIGH':
        col = Colors.redAccent;
        break;
      case 'MEDIUM':
        col = Colors.orangeAccent;
        break;
      default:
        col = Colors.blueAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: col.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(color: col, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
