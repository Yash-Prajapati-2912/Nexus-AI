import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../widgets/settings_tile.dart';
import '../widgets/settings_skeleton.dart';

class SettingsHomePage extends StatefulWidget {
  const SettingsHomePage({super.key});

  @override
  State<SettingsHomePage> createState() => _SettingsHomePageState();
}

class _SettingsHomePageState extends State<SettingsHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(LoadSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Preferences'),
        elevation: 0,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const SettingsSkeleton();
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: [
              _buildSectionHeader(context, 'Personalization & Display'),
              SettingsTile(
                icon: Icons.palette_outlined,
                title: 'Appearance & Theme',
                subtitle: 'Light, Dark, Dynamic Color, Font Scale',
                onTap: () => context.push(RouteNames.settingsAppearance),
              ),
              SettingsTile(
                icon: Icons.translate,
                title: 'Language & Region',
                subtitle: 'Language, Date/Time Format, Timezone',
                onTap: () => context.push(RouteNames.settingsLanguage),
              ),
              SettingsTile(
                icon: Icons.accessibility_new,
                title: 'Accessibility',
                subtitle: 'Large Text, High Contrast, Motion Reduction',
                onTap: () => context.push(RouteNames.settingsAccessibility),
              ),
              const Divider(height: 24),
              _buildSectionHeader(context, 'Security & Privacy'),
              SettingsTile(
                icon: Icons.security,
                title: 'Security & App Lock',
                subtitle: 'Biometrics, PIN, Session Timeout',
                onTap: () => context.push(RouteNames.settingsSecurity),
              ),
              SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy & Data Controls',
                subtitle: 'Analytics, AI Usage, History & Local Cache',
                onTap: () => context.push(RouteNames.settingsPrivacy),
              ),
              SettingsTile(
                icon: Icons.devices,
                title: 'Sessions & Connected Devices',
                subtitle: 'Manage Active Logins & Trusted Devices',
                onTap: () => context.push(RouteNames.settingsSessionManagement),
              ),
              const Divider(height: 24),
              _buildSectionHeader(context, 'Preferences & Services'),
              SettingsTile(
                icon: Icons.auto_awesome,
                title: 'AI Intelligence Preferences',
                subtitle: 'Personality, Response Length, Memory',
                onTap: () => context.push(RouteNames.settingsAiPreferences),
              ),
              SettingsTile(
                icon: Icons.notifications_none_outlined,
                title: 'Notification Preferences',
                subtitle: 'Push, In-App, Planner, Sound & Quiet Hours',
                onTap: () => context.push(RouteNames.settingsNotificationPreferences),
              ),
              SettingsTile(
                icon: Icons.cloud_sync_outlined,
                title: 'Backup & Restore',
                subtitle: 'Cloud Sync, Data Export, Restore Points',
                onTap: () => context.push(RouteNames.settingsBackupRestore),
              ),
              const Divider(height: 24),
              _buildSectionHeader(context, 'Developer & System'),
              SettingsTile(
                icon: Icons.developer_mode,
                title: 'Developer Options',
                subtitle: 'Environment, Network Logs, Feature Flags',
                onTap: () => context.push(RouteNames.settingsDeveloperOptions),
              ),
              SettingsTile(
                icon: Icons.info_outline,
                title: 'About Application',
                subtitle: 'Version, Licenses, Terms & Policies',
                onTap: () => context.push(RouteNames.settingsAbout),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
