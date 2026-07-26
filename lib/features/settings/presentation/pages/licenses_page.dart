import 'package:flutter/material.dart';

class LicensesPage extends StatelessWidget {
  const LicensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LicensePage(
      applicationName: 'Nexus AI',
      applicationVersion: '1.0.0+1',
      applicationIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.auto_awesome, size: 48, color: Theme.of(context).colorScheme.primary),
      ),
      applicationLegalese: '© 2026 Nexus AI Enterprise Operating System. All rights reserved.',
    );
  }
}
