import 'package:flutter/material.dart';

enum BadgeStatus { success, warning, error, info }

class AdminBadge extends StatelessWidget {
  final String label;
  final BadgeStatus status;

  const AdminBadge({
    super.key,
    required this.label,
    this.status = BadgeStatus.info,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status) {
      case BadgeStatus.success:
        bg = Colors.green.withOpacity(0.15);
        fg = Colors.green.shade700;
        break;
      case BadgeStatus.warning:
        bg = Colors.amber.withOpacity(0.15);
        fg = Colors.amber.shade800;
        break;
      case BadgeStatus.error:
        bg = Colors.red.withOpacity(0.15);
        fg = Colors.red.shade700;
        break;
      case BadgeStatus.info:
        bg = Colors.blue.withOpacity(0.15);
        fg = Colors.blue.shade700;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
