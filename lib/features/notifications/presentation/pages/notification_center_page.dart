import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/notification_item.dart';
import '../bloc/notification_bloc.dart';
import '../widgets/empty_notification_widget.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_header.dart';
import '../widgets/notification_skeleton.dart';

class NotificationCenterPage extends StatefulWidget {
  const NotificationCenterPage({super.key});

  @override
  State<NotificationCenterPage> createState() => _NotificationCenterPageState();
}

class _NotificationCenterPageState extends State<NotificationCenterPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const LoadNotificationsEvent());
  }

  final List<NotificationItem> _sampleNotifications = [
    NotificationItem(
      id: 'n1',
      userId: 'u1',
      title: 'Smart Planner: CS101 Assignment Due',
      body: 'Your Data Structures assignment is due in 3 hours. Complete it to keep your streak!',
      type: 'PLANNER',
      module: 'PLANNER',
      category: 'ASSIGNMENT',
      priority: 'HIGH',
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      deepLinkUrl: RouteNames.aiPlannerHome,
    ),

    NotificationItem(
      id: 'n2',
      userId: 'u1',
      title: 'AI Advisor: Unusual Spending Alert',
      body: 'Dining expenses exceed your weekly allocation by 18%. View AI savings tip.',
      type: 'FINANCE',
      module: 'FINANCE',
      category: 'BUDGET',
      priority: 'MEDIUM',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      deepLinkUrl: RouteNames.aiFinanceUnusualSpending,
    ),
    NotificationItem(
      id: 'n3',
      userId: 'u1',
      title: 'AI Mentor: Study Recommendation',
      body: 'Based on your wellness score, consider a 15-minute break before your evening session.',
      type: 'AI_MENTOR',
      module: 'MENTOR',
      category: 'MENTOR_REPLY',
      priority: 'LOW',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      deepLinkUrl: RouteNames.aiMentorHome,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Center', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => context.push(RouteNames.notificationsActivityCenter),
            tooltip: 'Activity Center',
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => context.push(RouteNames.notificationsPreferences),
            tooltip: 'Preferences',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<NotificationBloc>().add(const RefreshNotificationsEvent());
        },
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoadingState) {
              return ListView(
                children: const [
                  NotificationSkeleton(),
                  NotificationSkeleton(),
                  NotificationSkeleton(),
                ],
              );
            }

            final items = (state is NotificationLoadedState && state.notifications.isNotEmpty)
                ? state.notifications
                : _sampleNotifications;
            final unread = (state is NotificationLoadedState) ? state.unreadCount : 2;

            if (items.isEmpty) {
              return const EmptyNotificationWidget();
            }

            return Column(
              children: [
                NotificationHeader(
                  unreadCount: unread,
                  onMarkAllRead: () {
                    context.read<NotificationBloc>().add(const MarkAllReadEvent());
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return NotificationCard(
                        item: item,
                        onTap: () {
                          context.read<NotificationBloc>().add(MarkReadEvent(item.id));
                          if (item.deepLinkUrl != null) {
                            context.push(item.deepLinkUrl!);
                          } else {
                            context.push(RouteNames.notificationsDetails, extra: item);
                          }
                        },
                        onDismiss: () {
                          context.read<NotificationBloc>().add(DeleteNotificationEvent(item.id));
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
