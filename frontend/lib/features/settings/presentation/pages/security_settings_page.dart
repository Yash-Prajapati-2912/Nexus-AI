import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/security_bloc.dart';
import '../bloc/security_event.dart';
import '../bloc/security_state.dart';
import '../widgets/preference_card.dart';
import '../widgets/switch_tile.dart';
import '../widgets/security_card.dart';

class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Settings'),
      ),
      body: BlocConsumer<SecurityBloc, SecurityState>(
        listener: (context, state) {
          if (state is SecurityLoaded && state.statusMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.statusMessage!)),
            );
          } else if (state is SecurityError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final security = (state is SecurityLoaded) ? state.security : null;
          final timeout = security?.sessionTimeoutMinutes ?? 30;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const PreferenceCard(
                title: 'Biometrics & Passcode',
                subtitle: 'Device authentication and security options',
                child: Column(
                  children: [
                    SwitchTile(
                      icon: Icons.fingerprint,
                      title: 'Biometric Lock',
                      subtitle: 'Platform biometric authentication is not available on this device',
                      value: false,
                      onChanged: null,
                    ),
                    SwitchTile(
                      icon: Icons.pin,
                      title: 'PIN Lock',
                      subtitle: 'App PIN lock setup is not available yet',
                      value: false,
                      onChanged: null,
                    ),
                  ],
                ),
              ),
              PreferenceCard(
                title: 'Session Inactivity Timeout',
                subtitle: 'Automatically lock app when idle',
                child: DropdownButtonFormField<int>(
                  value: timeout,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Timeout Period',
                  ),
                  items: const [
                    DropdownMenuItem(value: 5, child: Text('5 minutes')),
                    DropdownMenuItem(value: 15, child: Text('15 minutes')),
                    DropdownMenuItem(value: 30, child: Text('30 minutes')),
                    DropdownMenuItem(value: 60, child: Text('1 hour')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      context.read<SecurityBloc>().add(ChangeSessionTimeoutEvent(val));
                    }
                  },
                ),
              ),
              PreferenceCard(
                title: 'Active Devices Security',
                subtitle: 'Manage active sessions across all platforms',
                child: SecurityCard(
                  title: 'Terminate Other Sessions',
                  description: 'Log out of all mobile & web devices except this one',
                  icon: Icons.phonelink_erase,
                  action: ElevatedButton(
                    onPressed: () => _confirmLogoutAllOtherDevices(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Logout All'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmLogoutAllOtherDevices(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Terminate Other Sessions?'),
        content: const Text(
          'Are you sure you want to log out of all other devices? All other active sessions will be terminated.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<SecurityBloc>().add(LogoutAllOtherDevicesEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout All'),
          ),
        ],
      ),
    );
  }
}
