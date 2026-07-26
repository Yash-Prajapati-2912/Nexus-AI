import 'package:flutter/material.dart';
import '../../domain/entities/security_settings.dart';
import '../widgets/security_card.dart';

class SecurityOverviewPage extends StatefulWidget {
  const SecurityOverviewPage({super.key});

  @override
  State<SecurityOverviewPage> createState() => _SecurityOverviewPageState();
}

class _SecurityOverviewPageState extends State<SecurityOverviewPage> {
  final SecuritySettings _security = SecuritySettings(
    twoFactorEnabled: true,
    activeSessionsCount: 2,
    trustedDevicesCount: 1,
    lastPasswordChange: DateTime.now().subtract(const Duration(days: 30)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security Overview')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SecurityCard(security: _security),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.key_rounded),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password change dialog opened')));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.phonelink_setup_rounded),
                  title: const Text('Two-Factor Authentication (2FA)'),
                  trailing: Text(_security.twoFactorEnabled ? 'Enabled' : 'Disabled', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.devices_rounded),
                  title: const Text('Logout Other Active Sessions'),
                  trailing: const Icon(Icons.exit_to_app_rounded, color: Colors.orangeAccent),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Other sessions logged out successfully!')));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
