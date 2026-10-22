import 'package:flutter/material.dart';

class WeeklyHeatmapWidget extends StatelessWidget {
  final Map<String, int> heatmapData; // Day string e.g. "Mon" -> intensity 0..4

  const WeeklyHeatmapWidget({super.key, required this.heatmapData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Activity Intensity Heatmap',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: days.map((day) {
            final intensity = (heatmapData[day] ?? 0).clamp(0, 4);
            Color boxColor;
            switch (intensity) {
              case 4:
                boxColor = const Color(0xFF047857);
                break;
              case 3:
                boxColor = const Color(0xFF10B981);
                break;
              case 2:
                boxColor = const Color(0xFF6EE7B7);
                break;
              case 1:
                boxColor = const Color(0xFFD1FAE5);
                break;
              default:
                boxColor = theme.colorScheme.surfaceContainerHighest;
                break;
            }

            return Column(
              children: [
                Container(
                  width: 36,
                  height: 48,
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Center(
                    child: Text(
                      intensity > 0 ? '$intensity' : '-',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: intensity >= 3
                            ? Colors.white
                            : (intensity > 0 ? Colors.black87 : theme.colorScheme.outline),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  day,
                  style: theme.textTheme.labelSmall,
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
