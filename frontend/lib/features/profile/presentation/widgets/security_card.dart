import 'package:flutter/material.dart';
import '../../domain/entities/security_settings.dart';

class SecurityCard extends StatelessWidget {
  final SecuritySettings security;

  const SecurityCard({super.key, required this.security});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.security_rounded, color: Colors.blueAccent, size: 20),
                const SizedBox(width: 8),
                Text('Security Overview', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            _Row(label: '2FA Status', value: security.twoFactorEnabled ? 'Enabled' : 'Disabled', isOk: security.twoFactorEnabled),
            _Row(label: 'Active Sessions', value: '${security.activeSessionsCount} active'),
            _Row(label: 'Trusted Devices', value: '${security.trustedDevicesCount} registered'),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool? isOk;

  const _Row({required this.label, required this.value, this.isOk});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final col = isOk == null ? theme.colorScheme.onSurface : (isOk! ? const Color(0xFF10B981) : Colors.orangeAccent);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: col)),
        ],
      ),
    );
  }
}
