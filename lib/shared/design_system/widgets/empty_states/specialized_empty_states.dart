import 'package:flutter/material.dart';
import 'app_empty_state.dart';

class NoTasksEmptyState extends StatelessWidget {
  final VoidCallback? onAddTask;

  const NoTasksEmptyState({super.key, this.onAddTask});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: 'No Tasks Scheduled',
      description: 'Your schedule is currently clear. Add a task to get started.',
      icon: Icons.task_alt_rounded,
      action: onAddTask != null
          ? ElevatedButton(onPressed: onAddTask, child: const Text('Add Task'))
          : null,
    );
  }
}

class NoNotificationsEmptyState extends StatelessWidget {
  const NoNotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      title: 'No Notifications',
      description: 'You are all caught up! Check back later for updates.',
      icon: Icons.notifications_none_rounded,
    );
  }
}

class NoInternetEmptyState extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetEmptyState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: 'No Connection',
      description: 'Please check your internet connection and try again.',
      icon: Icons.wifi_off_rounded,
      action: ElevatedButton(onPressed: onRetry, child: const Text('Retry Connection')),
    );
  }
}
