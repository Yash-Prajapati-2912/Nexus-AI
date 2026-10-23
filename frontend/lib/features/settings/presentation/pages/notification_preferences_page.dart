import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../../domain/entities/notification_preference_entity.dart';
import '../widgets/preference_card.dart';
import '../widgets/switch_tile.dart';

class NotificationPreferencesPage extends StatelessWidget {
  const NotificationPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Preferences'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final notif = (state is SettingsLoaded)
              ? state.settings.notificationPreferences
              : NotificationPreferenceEntity.initial();

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              PreferenceCard(
                title: 'Global Delivery Channels',
                subtitle: 'Master controls for push and in-app alerts',
                child: Column(
                  children: [
                    SwitchTile(
                      icon: Icons.notifications_active_outlined,
                      title: 'Push Notifications',
                      subtitle: 'Receive system alerts on lock screen',
                      value: notif.pushNotifications,
                      onChanged: (val) {
                        final updated = notif.copyWith(pushNotifications: val);
                        context.read<SettingsBloc>().add(UpdateNotificationPreferencesEvent(updated));
                      },
                    ),
                    SwitchTile(
                      icon: Icons.campaign_outlined,
                      title: 'In-App Banner Notifications',
                      subtitle: 'Show real-time toast banners inside application',
                      value: notif.inAppNotifications,
                      onChanged: (val) {
                        final updated = notif.copyWith(inAppNotifications: val);
                        context.read<SettingsBloc>().add(UpdateNotificationPreferencesEvent(updated));
                      },
                    ),
                  ],
                ),
              ),
              PreferenceCard(
                title: 'Category Alerts',
                subtitle: 'Enable or disable alerts per module',
                child: Column(
                  children: [
                    SwitchTile(
                      icon: Icons.calendar_month_outlined,
                      title: 'Planner & Assignment Reminders',
                      subtitle: 'Upcoming deadlines & study session alerts',
                      value: notif.plannerNotifications,
                      onChanged: (val) {
                        final updated = notif.copyWith(plannerNotifications: val);
                        context.read<SettingsBloc>().add(UpdateNotificationPreferencesEvent(updated));
                      },
                    ),
                    SwitchTile(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Finance & Budget Alerts',
                      subtitle: 'Budget limits & unusual spending warnings',
                      value: notif.financeNotifications,
                      onChanged: (val) {
                        final updated = notif.copyWith(financeNotifications: val);
                        context.read<SettingsBloc>().add(UpdateNotificationPreferencesEvent(updated));
                      },
                    ),
                    SwitchTile(
                      icon: Icons.smart_toy_outlined,
                      title: 'AI Mentor Recommendations',
                      subtitle: 'Personalized wellness & study tips',
                      value: notif.aiNotifications,
                      onChanged: (val) {
                        final updated = notif.copyWith(aiNotifications: val);
                        context.read<SettingsBloc>().add(UpdateNotificationPreferencesEvent(updated));
                      },
                    ),
                  ],
                ),
              ),
              PreferenceCard(
                title: 'Sound & Quiet Hours',
                subtitle: 'Manage haptics and silent schedules',
                child: Column(
                  children: [
                    SwitchTile(
                      icon: Icons.volume_up_outlined,
                      title: 'Sound Effects',
                      subtitle: 'Play custom notification audio',
                      value: notif.soundEnabled,
                      onChanged: (val) {
                        final updated = notif.copyWith(soundEnabled: val);
                        context.read<SettingsBloc>().add(UpdateNotificationPreferencesEvent(updated));
                      },
                    ),
                    SwitchTile(
                      icon: Icons.vibration_outlined,
                      title: 'Vibration Haptics',
                      subtitle: 'Vibrate on critical alerts',
                      value: notif.vibrationEnabled,
                      onChanged: (val) {
                        final updated = notif.copyWith(vibrationEnabled: val);
                        context.read<SettingsBloc>().add(UpdateNotificationPreferencesEvent(updated));
                      },
                    ),
                    SwitchTile(
                      icon: Icons.bedtime_outlined,
                      title: 'Quiet Hours Schedule',
                      subtitle: 'Mute non-urgent notifications during sleep (${notif.quietHoursStart} - ${notif.quietHoursEnd})',
                      value: notif.quietHoursEnabled,
                      onChanged: (val) {
                        final updated = notif.copyWith(quietHoursEnabled: val);
                        context.read<SettingsBloc>().add(UpdateNotificationPreferencesEvent(updated));
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
