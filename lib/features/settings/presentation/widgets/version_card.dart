import 'package:flutter/material.dart';
import '../../../../shared/branding/nexus_logo.dart';

class VersionCard extends StatelessWidget {
  final String appVersion;
  final String buildNumber;

  const VersionCard({
    super.key,
    required this.appVersion,
    required this.buildNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        NexusLogo(
          variant: LogoVariant.ecosystem,
          markSize: 90,
          logoTheme: isDark ? LogoTheme.dark : LogoTheme.light,
        ),
        const SizedBox(height: 12),
        Chip(
          label: Text('v$appVersion ($buildNumber)'),
          backgroundColor: theme.colorScheme.secondaryContainer,
          labelStyle: TextStyle(color: theme.colorScheme.onSecondaryContainer),
        ),
      ],
    );
  }
}
