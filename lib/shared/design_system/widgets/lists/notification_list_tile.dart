import 'package:flutter/material.dart';

class NotificationListTile extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final bool isRead;
  final VoidCallback onTap;

  const NotificationListTile({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isRead ? Colors.grey.shade300 : Theme.of(context).colorScheme.primary,
        child: Icon(Icons.notifications_outlined, color: isRead ? Colors.black : Colors.white),
      ),
      title: Text(title, style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold)),
      subtitle: Text(body),
      trailing: Text(time, style: Theme.of(context).textTheme.labelSmall),
      onTap: onTap,
    );
  }
}
