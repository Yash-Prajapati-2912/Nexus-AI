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
          final isBiometric = security?.isBiometricEnabled ?? false;
          final isPin = security?.isPinLockEnabled ?? false;
          final timeout = security?.sessionTimeoutMinutes ?? 30;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              PreferenceCard(
                title: 'Biometrics & Passcode',
                subtitle: 'Protect your account using device authentication',
                child: Column(
                  children: [
                    SwitchTile(
                      icon: Icons.fingerprint,
                      title: 'Biometric Lock',
                      subtitle: 'Use Fingerprint / Face ID to unlock Nexus AI',
                      value: isBiometric,
                      onChanged: (val) => context.read<SecurityBloc>().add(ToggleBiometricEvent(val)),
                    ),
                    SwitchTile(
                      icon: Icons.pin,
                      title: 'PIN Lock',
                      subtitle: 'Require 4-digit security PIN upon app launch',
                      value: isPin,
                      onChanged: (val) => context.read<SecurityBloc>().add(TogglePinLockEvent(val)),
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
                    onPressed: () {
                      context.read<SecurityBloc>().add(LogoutAllOtherDevicesEvent());
                    },
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
}
