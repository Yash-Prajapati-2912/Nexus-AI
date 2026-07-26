import 'package:flutter/material.dart';

class NotificationCategoriesPage extends StatelessWidget {
  const NotificationCategoriesPage({super.key});

  final List<Map<String, dynamic>> _categories = const [
    {'title': 'Planner Alerts', 'icon': Icons.calendar_today_rounded, 'count': 4},
    {'title': 'Finance & Budget', 'icon': Icons.account_balance_wallet_rounded, 'count': 2},
    {'title': 'AI Mentor Recommendations', 'icon': Icons.auto_awesome, 'count': 5},
    {'title': 'Security Alerts', 'icon': Icons.security_rounded, 'count': 0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Categories')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return Card(
            child: ListTile(
              leading: Icon(cat['icon'] as IconData, color: Theme.of(context).colorScheme.primary),
              title: Text(cat['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: Chip(label: Text('${cat["count"]} Alerts')),
            ),
          );
        },
      ),
    );
  }
}
