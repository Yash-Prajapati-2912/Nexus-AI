import 'package:flutter/material.dart';

class NotificationFiltersPage extends StatelessWidget {
  const NotificationFiltersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Filters')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(title: Text('Filter by Priority: High / Medium / Low')),
          ListTile(title: Text('Filter by Module: Planner, Finance, AI Mentor')),
          ListTile(title: Text('Filter by Read Status: Unread Only')),
        ],
      ),
    );
  }
}
