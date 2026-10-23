import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';
import '../widgets/preference_card.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  static const List<Map<String, String>> _seedColors = [
    {'name': 'Nexus Purple', 'hex': '0xFF6750A4'},
    {'name': 'Ocean Blue', 'hex': '0xFF0061A4'},
    {'name': 'Emerald Green', 'hex': '0xFF006E4C'},
    {'name': 'Sunset Orange', 'hex': '0xFFA23F00'},
    {'name': 'Crimson Rose', 'hex': '0xFFB91D47'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          final currentHex = state.theme.primaryColorHex;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              PreferenceCard(
                title: 'Primary Seed Color',
                subtitle: 'Select your preferred Material 3 primary palette',
                child: Column(
                  children: _seedColors.map((colorMap) {
                    final hex = colorMap['hex']!;
                    final isSelected = hex == currentHex;
                    final colorVal = Color(int.parse(hex));

                    return ListTile(
                      leading: CircleAvatar(backgroundColor: colorVal),
                      title: Text(colorMap['name']!),
                      trailing: isSelected ? Icon(Icons.check, color: theme.colorScheme.primary) : null,
                      onTap: () => context.read<ThemeBloc>().add(ChangePrimaryColorEvent(hex)),
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
