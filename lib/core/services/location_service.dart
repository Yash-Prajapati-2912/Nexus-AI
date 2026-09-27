import 'package:flutter/material.dart';

/// Service responsible for location permission handling and timezone resolution.
class LocationService {
  /// Prompts the user with a Location Permission dialogue and resolves the system time zone.
  static Future<String?> requestLocationAndTimezone(BuildContext context) async {
    final theme = Theme.of(context);

    final bool? allowed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.location_on_rounded, color: theme.colorScheme.primary, size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Location Permission Required',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: const Text(
          'Nexus AI needs location permission to automatically determine your local time zone and regional settings for accurate study reminders and calendar schedule synchronization.',
          style: TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            icon: const Icon(Icons.check_circle_rounded, size: 18),
            label: const Text('Allow & Detect Timezone'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );

    if (allowed != true) {
      return null;
    }

    // Resolve system timezone name & offset
    final now = DateTime.now();
    final timeZoneName = now.timeZoneName;
    final offsetHours = now.timeZoneOffset.inHours;
    final offsetMinutes = (now.timeZoneOffset.inMinutes % 60).abs();
    final sign = now.timeZoneOffset.isNegative ? '-' : '+';
    final formattedOffset = 'UTC$sign${offsetHours.abs().toString().padLeft(2, '0')}:${offsetMinutes.toString().padLeft(2, '0')}';

    final resolvedTimezone = timeZoneName.isNotEmpty && !timeZoneName.contains('+') && !timeZoneName.contains('-')
        ? '$timeZoneName ($formattedOffset)'
        : formattedOffset;

    return resolvedTimezone;
  }
}
