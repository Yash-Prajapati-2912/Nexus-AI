import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';
import '../widgets/preference_card.dart';
import '../widgets/language_selector.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language & Region'),
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          final lang = state.language;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              PreferenceCard(
                title: 'Application Language',
                subtitle: 'Select primary localization language',
                child: LanguageSelector(
                  currentLanguageCode: lang.languageCode,
                  onLanguageSelected: (code) {
                    final updated = lang.copyWith(languageCode: code);
                    context.read<ThemeBloc>().add(UpdateLanguageSettingsEvent(updated));
                  },
                ),
              ),
              PreferenceCard(
                title: 'Regional Formats',
                subtitle: 'Timezone and formatting rules',
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Date Format'),
                      trailing: Text(lang.dateFormat),
                    ),
                    ListTile(
                      title: const Text('Time Format'),
                      trailing: Text(lang.timeFormat),
                    ),
                    ListTile(
                      title: const Text('System Timezone'),
                      trailing: Text(lang.timezone),
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
