import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/session_entity.dart';
import '../bloc/session_bloc.dart';
import '../bloc/session_event.dart';
import '../bloc/session_state.dart';
import '../widgets/preference_card.dart';
import '../widgets/device_card.dart';
import '../widgets/preference_loader.dart';

class SessionManagementPage extends StatefulWidget {
  const SessionManagementPage({super.key});

  @override
  State<SessionManagementPage> createState() => _SessionManagementPageState();
}

class _SessionManagementPageState extends State<SessionManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<SessionBloc>().add(LoadSessionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions & Devices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.devices_other),
            onPressed: () => context.push(RouteNames.settingsConnectedDevices),
          ),
        ],
      ),
      body: BlocConsumer<SessionBloc, SessionState>(
        listener: (context, state) {
          if (state is SessionLoaded && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
          }
        },
        builder: (context, state) {
          if (state is SessionLoading) {
            return const PreferenceLoader(label: 'Fetching active sessions...');
          }

          final List<SessionEntity> sessions =
              (state is SessionLoaded) ? state.sessions : <SessionEntity>[];

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              PreferenceCard(
                title: 'Active Logged In Sessions',
                subtitle: 'All devices currently authenticated with your account',
                child: Column(
                  children: sessions.map((SessionEntity sess) {
                    final timeStr = '${sess.lastActive.hour}:${sess.lastActive.minute}';
                    return DeviceCard(
                      deviceName: sess.deviceName,
                      platform: '${sess.deviceType} (${sess.ipAddress})',
                      lastSeen: timeStr,
                      isCurrentDevice: sess.isCurrentSession,
                      onRemove: sess.isCurrentSession
                          ? null
                          : () {
                              context.read<SessionBloc>().add(TerminateSessionEvent(sess.sessionId));
                            },
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
