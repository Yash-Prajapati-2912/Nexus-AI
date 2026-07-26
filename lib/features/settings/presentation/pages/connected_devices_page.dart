import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/connected_device_entity.dart';
import '../bloc/session_bloc.dart';
import '../bloc/session_event.dart';
import '../bloc/session_state.dart';
import '../widgets/preference_card.dart';
import '../widgets/device_card.dart';

class ConnectedDevicesPage extends StatelessWidget {
  const ConnectedDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trusted Connected Devices'),
      ),
      body: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          final List<ConnectedDeviceEntity> devices =
              (state is SessionLoaded) ? state.devices : <ConnectedDeviceEntity>[];

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              PreferenceCard(
                title: 'Trusted Hardware Devices',
                subtitle: 'Registered devices authorized for biometric passkeys',
                child: Column(
                  children: devices.map((ConnectedDeviceEntity dev) {
                    return DeviceCard(
                      deviceName: dev.name,
                      platform: '${dev.platform} • App v${dev.appVersion}',
                      lastSeen: 'Recently',
                      isCurrentDevice: false,
                      onRemove: () {
                        context.read<SessionBloc>().add(RemoveDeviceEvent(dev.deviceId));
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
