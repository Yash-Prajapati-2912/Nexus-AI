import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';
import '../widgets/preference_card.dart';
import '../widgets/switch_tile.dart';
import '../widgets/accessibility_preview_widget.dart';

class AccessibilitySettingsPage extends StatelessWidget {
  const AccessibilitySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility'),
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          final acc = state.accessibility;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              AccessibilityPreviewWidget(accessibility: acc),
              const SizedBox(height: 16),
              PreferenceCard(
                title: 'Visual Accessibility',
                subtitle: 'Adjust text size and contrast for readability',
                child: Column(
                  children: [
                    SwitchTile(
                      icon: Icons.format_size,
                      title: 'Large Text',
                      subtitle: 'Increase font sizes across all screens',
                      value: acc.largeTextEnabled,
                      onChanged: (val) {
                        final updated = acc.copyWith(largeTextEnabled: val);
                        context.read<ThemeBloc>().add(UpdateAccessibilitySettingsEvent(updated));
                      },
                    ),
                    SwitchTile(
                      icon: Icons.contrast,
                      title: 'High Contrast Mode',
                      subtitle: 'Enhance contrast ratio between background and text',
                      value: acc.highContrastEnabled,
                      onChanged: (val) {
                        final updated = acc.copyWith(highContrastEnabled: val);
                        context.read<ThemeBloc>().add(UpdateAccessibilitySettingsEvent(updated));
                      },
                    ),
                    SwitchTile(
                      icon: Icons.motion_photos_off,
                      title: 'Reduce Motion',
                      subtitle: 'Minimize complex page transitions and dynamic animations',
                      value: acc.reduceMotionEnabled,
                      onChanged: (val) {
                        final updated = acc.copyWith(reduceMotionEnabled: val);
                        context.read<ThemeBloc>().add(UpdateAccessibilitySettingsEvent(updated));
                      },
                    ),
                    SwitchTile(
                      icon: Icons.record_voice_over,
                      title: 'Screen Reader Optimization',
                      subtitle: 'Optimize semantics tree for TalkBack / VoiceOver',
                      value: acc.screenReaderOptimized,
                      onChanged: (val) {
                        final updated = acc.copyWith(screenReaderOptimized: val);
                        context.read<ThemeBloc>().add(UpdateAccessibilitySettingsEvent(updated));
                      },
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
