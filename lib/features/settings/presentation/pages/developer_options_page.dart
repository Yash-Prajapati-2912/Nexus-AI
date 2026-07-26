import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/developer_bloc.dart';
import '../bloc/developer_event.dart';
import '../bloc/developer_state.dart';
import '../widgets/preference_card.dart';
import '../widgets/switch_tile.dart';

class DeveloperOptionsPage extends StatelessWidget {
  const DeveloperOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Options (Debug)'),
      ),
      body: BlocConsumer<DeveloperBloc, DeveloperState>(
        listener: (context, state) {
          if (state is DeveloperLoaded && state.toast != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.toast!)),
            );
          }
        },
        builder: (context, state) {
          final settings = (state is DeveloperLoaded) ? state.settings : null;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              PreferenceCard(
                title: 'Environment & API Endpoint',
                subtitle: 'Switch backend API gateway',
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: settings?.environment ?? 'Development',
                      decoration: const InputDecoration(
                        labelText: 'Target Environment',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Development',
                          child: Text('Development (http://localhost:3000/api/v1)'),
                        ),
                        DropdownMenuItem(
                          value: 'Staging',
                          child: Text('Staging (https://staging.api.nexusai.com/v1)'),
                        ),
                        DropdownMenuItem(
                          value: 'Production',
                          child: Text('Production (https://api.nexusai.com/v1)'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          String url = 'http://localhost:3000/api/v1';
                          if (val == 'Staging') url = 'https://staging.api.nexusai.com/v1';
                          if (val == 'Production') url = 'https://api.nexusai.com/v1';
                          context.read<DeveloperBloc>().add(ChangeEnvironmentEvent(val, url));
                        }
                      },
                    ),
                  ],
                ),
              ),
              PreferenceCard(
                title: 'Logging & Inspector Tools',
                subtitle: 'Dio network logger and performance overlay',
                child: Column(
                  children: [
                    SwitchTile(
                      icon: Icons.alt_route_outlined,
                      title: 'Enable Network Dio Logs',
                      subtitle: 'Print HTTP requests & responses to console log',
                      value: settings?.enableDioLogger ?? true,
                      onChanged: (val) {
                        context.read<DeveloperBloc>().add(ToggleNetworkLogsEvent(val));
                      },
                    ),
                    SwitchTile(
                      icon: Icons.speed_outlined,
                      title: 'Performance Overlay',
                      subtitle: 'Display GPU/CPU rasterization charts overlay',
                      value: settings?.showPerformanceOverlay ?? false,
                      onChanged: (val) {
                        context.read<DeveloperBloc>().add(TogglePerformanceOverlayEvent(val));
                      },
                    ),
                  ],
                ),
              ),
              PreferenceCard(
                title: 'Dynamic Feature Flags',
                subtitle: 'Toggle experimental system feature flags',
                child: Column(
                  children: (settings?.featureFlags ?? {}).entries.map((entry) {
                    return SwitchTile(
                      icon: Icons.extension_outlined,
                      title: entry.key,
                      value: entry.value,
                      onChanged: (val) {
                        context.read<DeveloperBloc>().add(ToggleFeatureFlagEvent(entry.key, val));
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
