import 'package:flutter/material.dart';
import '../../domain/entities/theme_entity.dart';

class ThemePreviewWidget extends StatelessWidget {
  final ThemeEntity themeEntity;

  const ThemePreviewWidget({super.key, required this.themeEntity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primary,
                radius: 16,
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: theme.colorScheme.secondary,
                radius: 16,
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: theme.colorScheme.tertiary,
                radius: 16,
              ),
              const Spacer(),
              Text(
                'Material 3 Palette',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Primary Color Preview',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Active Theme Mode: ${themeEntity.themeMode.name.toUpperCase()}',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
