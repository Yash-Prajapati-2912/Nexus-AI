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
                child: devices.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.devices_other, size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                'No trusted hardware devices found',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: devices.map((ConnectedDeviceEntity dev) {
                          return DeviceCard(
                            deviceName: dev.name,
                            platform: '${dev.platform} • App v${dev.appVersion}',
                            lastSeen: 'Recently',
                            isCurrentDevice: false,
                            onRemove: () => _confirmRemoveDevice(context, dev),
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

  void _confirmRemoveDevice(BuildContext context, ConnectedDeviceEntity device) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove Trusted Device?'),
        content: Text('Are you sure you want to remove "${device.name}" from your trusted devices list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<SessionBloc>().add(RemoveDeviceEvent(device.deviceId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
