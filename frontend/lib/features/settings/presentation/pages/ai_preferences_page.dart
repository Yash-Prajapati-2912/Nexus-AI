import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../../domain/entities/ai_preferences_entity.dart';
import '../widgets/preference_card.dart';
import '../widgets/switch_tile.dart';

class AIPreferencesPage extends StatelessWidget {
  const AIPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Preferences'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final ai = (state is SettingsLoaded)
              ? state.settings.aiPreferences
              : AIPreferencesEntity.initial();

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              PreferenceCard(
                title: 'AI Personality & Response Style',
                subtitle: 'Customize how your AI Assistant communicates',
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: ai.responseStyle,
                      decoration: const InputDecoration(
                        labelText: 'Response Style',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'CONCISE', child: Text('Concise & Direct')),
                        DropdownMenuItem(value: 'BALANCED', child: Text('Balanced & Clear')),
                        DropdownMenuItem(value: 'DETAILED', child: Text('Detailed & In-depth')),
                        DropdownMenuItem(value: 'ACADEMIC', child: Text('Academic & Formal')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          final updated = ai.copyWith(responseStyle: val);
                          context.read<SettingsBloc>().add(UpdateAIPreferencesEvent(updated));
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: ai.personality,
                      decoration: const InputDecoration(
                        labelText: 'Mentor Personality Tone',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Professional', child: Text('Professional Tutor')),
                        DropdownMenuItem(value: 'Friendly', child: Text('Friendly Study Buddy')),
                        DropdownMenuItem(value: 'Strict', child: Text('Strict Accountability Partner')),
                        DropdownMenuItem(value: 'Socratic', child: Text('Socratic Guide')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          final updated = ai.copyWith(personality: val);
                          context.read<SettingsBloc>().add(UpdateAIPreferencesEvent(updated));
                        }
                      },
                    ),
                  ],
                ),
              ),
              PreferenceCard(
                title: 'Generation Settings',
                subtitle: 'Output stream and context memory',
                child: Column(
                  children: [
                    SwitchTile(
                      icon: Icons.stream,
                      title: 'Streaming Responses',
                      subtitle: 'Stream AI output token by token in real-time',
                      value: ai.streamingResponses,
                      onChanged: (val) {
                        final updated = ai.copyWith(streamingResponses: val);
                        context.read<SettingsBloc>().add(UpdateAIPreferencesEvent(updated));
                      },
                    ),
                    SwitchTile(
                      icon: Icons.memory,
                      title: 'Context Memory',
                      subtitle: 'Retain recent chat context across app sessions',
                      value: ai.contextMemoryEnabled,
                      onChanged: (val) {
                        final updated = ai.copyWith(contextMemoryEnabled: val);
                        context.read<SettingsBloc>().add(UpdateAIPreferencesEvent(updated));
                      },
                    ),
                    SwitchTile(
                      icon: Icons.lightbulb_outline,
                      title: 'Proactive Smart Suggestions',
                      subtitle: 'Show smart action prompts in planner & finance hubs',
                      value: ai.suggestionsEnabled,
                      onChanged: (val) {
                        final updated = ai.copyWith(suggestionsEnabled: val);
                        context.read<SettingsBloc>().add(UpdateAIPreferencesEvent(updated));
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
