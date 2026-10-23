import 'package:flutter/material.dart';

class TimelineCard extends StatelessWidget {
  final String dateTitle;
  final List<Widget> children;

  const TimelineCard({super.key, required this.dateTitle, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateTitle, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
}
