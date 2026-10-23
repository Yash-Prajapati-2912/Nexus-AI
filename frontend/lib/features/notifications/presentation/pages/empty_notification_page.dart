import 'package:flutter/material.dart';
import '../widgets/empty_notification_widget.dart';

class EmptyNotificationPage extends StatelessWidget {
  const EmptyNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const EmptyNotificationWidget(),
    );
  }
}
