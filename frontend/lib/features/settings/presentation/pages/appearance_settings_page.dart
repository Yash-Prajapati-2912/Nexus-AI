import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';
import '../../domain/entities/theme_entity.dart';
import '../widgets/preference_card.dart';
import '../widgets/theme_card.dart';
import '../widgets/switch_tile.dart';
import '../widgets/theme_preview_widget.dart';

class AppearanceSettingsPage extends StatelessWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance Settings'),
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          final themeEntity = state.theme;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ThemePreviewWidget(themeEntity: themeEntity),
              const SizedBox(height: 16),
              PreferenceCard(
                title: 'Theme Mode',
                subtitle: 'Choose your default app appearance',
                child: Column(
                  children: [
                    ThemeCard(
                      title: 'System Default',
                      icon: Icons.brightness_auto,
                      isSelected: themeEntity.themeMode == AppThemeMode.system,
                      onTap: () => context.read<ThemeBloc>().add(const ChangeThemeModeEvent(AppThemeMode.system)),
                    ),
                    const SizedBox(height: 8),
                    ThemeCard(
                      title: 'Light Theme',
                      icon: Icons.light_mode,
                      isSelected: themeEntity.themeMode == AppThemeMode.light,
                      onTap: () => context.read<ThemeBloc>().add(const ChangeThemeModeEvent(AppThemeMode.light)),
                    ),
                    const SizedBox(height: 8),
                    ThemeCard(
                      title: 'Dark Theme',
                      icon: Icons.dark_mode,
                      isSelected: themeEntity.themeMode == AppThemeMode.dark,
                      onTap: () => context.read<ThemeBloc>().add(const ChangeThemeModeEvent(AppThemeMode.dark)),
                    ),
                  ],
                ),
              ),
              PreferenceCard(
                title: 'Material 3 & Dynamic Color',
                subtitle: 'Customize accent colors and dynamic palette',
                child: Column(
                  children: [
                    SwitchTile(
                      icon: Icons.color_lens_outlined,
                      title: 'Use Dynamic System Colors',
                      subtitle: 'Extract colors from device wallpaper (Android 12+)',
                      value: themeEntity.useDynamicColor,
                      onChanged: (val) => context.read<ThemeBloc>().add(ToggleDynamicColorEvent(val)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.palette_outlined),
                      title: const Text('Detailed Theme Customization'),
                      subtitle: const Text('Primary seed color & palette generator'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(RouteNames.settingsTheme),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
