import 'package:flutter/material.dart';
import '../../domain/entities/accessibility_entity.dart';

class AccessibilityPreviewWidget extends StatelessWidget {
  final AccessibilityEntity accessibility;

  const AccessibilityPreviewWidget({super.key, required this.accessibility});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontMultiplier = accessibility.largeTextEnabled ? 1.25 : 1.0;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: accessibility.highContrastEnabled
            ? Colors.black
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: accessibility.highContrastEnabled ? Colors.white : theme.colorScheme.outlineVariant,
          width: accessibility.highContrastEnabled ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live Accessibility Preview',
            style: theme.textTheme.titleMedium?.copyWith(
              color: accessibility.highContrastEnabled ? Colors.white : theme.colorScheme.primary,
              fontSize: 16.0 * fontMultiplier,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This card previews text scaling, high contrast colors, and touch target adjustments in real-time.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: accessibility.highContrastEnabled ? Colors.white70 : theme.colorScheme.onSurface,
              fontSize: 14.0 * fontMultiplier,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                120 * accessibility.touchTargetScale,
                48 * accessibility.touchTargetScale,
              ),
              backgroundColor: accessibility.highContrastEnabled
                  ? Colors.yellow
                  : theme.colorScheme.primary,
              foregroundColor: accessibility.highContrastEnabled
                  ? Colors.black
                  : theme.colorScheme.onPrimary,
            ),
            child: Text(
              'Sample Button',
              style: TextStyle(fontSize: 14.0 * fontMultiplier, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
