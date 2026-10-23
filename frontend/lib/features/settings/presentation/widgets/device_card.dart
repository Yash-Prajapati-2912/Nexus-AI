import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String platform;
  final String lastSeen;
  final bool isCurrentDevice;
  final VoidCallback? onRemove;

  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.platform,
    required this.lastSeen,
    required this.isCurrentDevice,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isCurrentDevice
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.2)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isCurrentDevice ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(
            platform.toLowerCase().contains('android') || platform.toLowerCase().contains('ios')
                ? Icons.smartphone
                : Icons.laptop,
            color: theme.colorScheme.primary,
            size: 32,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      deviceName,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (isCurrentDevice) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'THIS DEVICE',
                          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onPrimary),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$platform • Active $lastSeen',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (!isCurrentDevice && onRemove != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
