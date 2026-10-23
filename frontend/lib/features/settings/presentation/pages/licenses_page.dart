import 'package:flutter/material.dart';
import '../../../../shared/branding/nexus_logo.dart';

class LicensesPage extends StatelessWidget {
  const LicensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LicensePage(
      applicationName: 'Nexus AI',
      applicationVersion: '1.0.0+1',
      applicationIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NexusLogoMark(size: 48, isDark: isDark),
      ),
      applicationLegalese: '© 2026 Nexus AI Enterprise Operating System. All rights reserved.',
    );
  }
}
