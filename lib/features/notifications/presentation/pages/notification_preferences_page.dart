import 'package:flutter/material.dart';
import '../widgets/notification_preference_tile.dart';

class NotificationPreferencesPage extends StatefulWidget {
  const NotificationPreferencesPage({super.key});

  @override
  State<NotificationPreferencesPage> createState() => _NotificationPreferencesPageState();
}

class _NotificationPreferencesPageState extends State<NotificationPreferencesPage> {
  bool _pushEnabled = true;
  bool _inAppEnabled = true;
  bool _emailEnabled = true;
  bool _plannerAlerts = true;
  bool _financeAlerts = true;
  bool _aiAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Preferences')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NotificationPreferenceTile(
            title: 'Push Notifications',
            subtitle: 'Receive real-time mobile push notifications',
            value: _pushEnabled,
            onChanged: (val) => setState(() => _pushEnabled = val),
          ),
          const Divider(),
          NotificationPreferenceTile(
            title: 'In-App Notifications',
            subtitle: 'Display banner alerts inside the app',
            value: _inAppEnabled,
            onChanged: (val) => setState(() => _inAppEnabled = val),
          ),
          const Divider(),
          NotificationPreferenceTile(
            title: 'Email Reports & Alerts',
            subtitle: 'Receive weekly summaries via email',
            value: _emailEnabled,
            onChanged: (val) => setState(() => _emailEnabled = val),
          ),
          const Divider(),
          NotificationPreferenceTile(
            title: 'Smart Planner Alerts',
            subtitle: 'Reminders for deadlines, tasks, and exams',
            value: _plannerAlerts,
            onChanged: (val) => setState(() => _plannerAlerts = val),
          ),
          const Divider(),
          NotificationPreferenceTile(
            title: 'Smart Finance Warnings',
            subtitle: 'Budget overspend and savings milestone alerts',
            value: _financeAlerts,
            onChanged: (val) => setState(() => _financeAlerts = val),
          ),
          const Divider(),
          NotificationPreferenceTile(
            title: 'AI Mentor & Coach Updates',
            subtitle: 'Proactive recommendations from AI Mentor',
            value: _aiAlerts,
            onChanged: (val) => setState(() => _aiAlerts = val),
          ),
        ],
      ),
    );
  }
}
