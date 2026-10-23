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
                child: sessions.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.devices, size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                'No active remote sessions found',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: sessions.map((SessionEntity sess) {
                          final timeStr = '${sess.lastActive.hour.toString().padLeft(2, '0')}:${sess.lastActive.minute.toString().padLeft(2, '0')}';
                          return DeviceCard(
                            deviceName: sess.deviceName,
                            platform: '${sess.deviceType} (${sess.ipAddress})',
                            lastSeen: timeStr,
                            isCurrentDevice: sess.isCurrentSession,
                            onRemove: sess.isCurrentSession
                                ? null
                                : () => _confirmTerminateSession(context, sess),
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

  void _confirmTerminateSession(BuildContext context, SessionEntity session) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Terminate Session?'),
        content: Text('Are you sure you want to terminate the session on "${session.deviceName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<SessionBloc>().add(TerminateSessionEvent(session.sessionId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Terminate'),
          ),
        ],
      ),
    );
  }
}
