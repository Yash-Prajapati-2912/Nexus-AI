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

            if (state is NotificationFailureState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded, size: 48, color: Theme.of(context).colorScheme.error),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load notifications',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<NotificationBloc>().add(const LoadNotificationsEvent());
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final items = (state is NotificationLoadedState) ? state.notifications : <NotificationItem>[];
            final unread = (state is NotificationLoadedState) ? state.unreadCount : 0;

            if (items.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const EmptyNotificationWidget(),
                  ),
                ],
              );
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
