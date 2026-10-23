import 'package:flutter/material.dart';

class RiskIndicator extends StatelessWidget {
  final String riskLevel; // LOW, MODERATE, HIGH_RISK

  const RiskIndicator({super.key, required this.riskLevel});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (riskLevel.toUpperCase()) {
      case 'HIGH_RISK':
      case 'HIGH':
        color = Colors.redAccent;
        label = 'HIGH RISK';
        break;
      case 'MODERATE':
        color = Colors.orangeAccent;
        label = 'MODERATE RISK';
        break;
      default:
        color = const Color(0xFF10B981);
        label = 'LOW RISK';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(35),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
