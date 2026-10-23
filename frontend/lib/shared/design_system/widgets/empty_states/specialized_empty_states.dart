import 'package:flutter/material.dart';
import 'app_empty_state.dart';

class NoTasksEmptyState extends StatelessWidget {
  final VoidCallback? onAddTask;

  const NoTasksEmptyState({super.key, this.onAddTask});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: 'Your planner is clear',
      description: 'You have no upcoming tasks or assignments. Create a task to stay organized.',
      icon: Icons.task_alt_rounded,
      action: onAddTask != null
          ? ElevatedButton(onPressed: onAddTask, child: const Text('Create Task'))
          : null,
    );
  }
}

class NoExpensesEmptyState extends StatelessWidget {
  final VoidCallback? onAddExpense;

  const NoExpensesEmptyState({super.key, this.onAddExpense});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: 'No expenses recorded this month',
      description: 'Track your spending habits by logging your first expense or transaction.',
      icon: Icons.account_balance_wallet_outlined,
      action: onAddExpense != null
          ? ElevatedButton(onPressed: onAddExpense, child: const Text('Add Expense'))
          : null,
    );
  }
}

class NoConversationsEmptyState extends StatelessWidget {
  final VoidCallback? onStartChat;

  const NoConversationsEmptyState({super.key, this.onStartChat});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: 'Start a conversation with Nexus AI',
      description: 'Ask for academic guidance, study planning, or instant problem solving.',
      icon: Icons.auto_awesome_rounded,
      action: onStartChat != null
          ? ElevatedButton(onPressed: onStartChat, child: const Text('New Chat'))
          : null,
    );
  }
}

class NoSavingsGoalsEmptyState extends StatelessWidget {
  final VoidCallback? onCreateGoal;

  const NoSavingsGoalsEmptyState({super.key, this.onCreateGoal});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: 'Create your first savings goal',
      description: 'Set financial targets for tuition, tech upgrades, or emergency funds.',
      icon: Icons.savings_outlined,
      action: onCreateGoal != null
          ? ElevatedButton(onPressed: onCreateGoal, child: const Text('Create Goal'))
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
