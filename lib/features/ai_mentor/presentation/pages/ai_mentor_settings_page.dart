import 'package:flutter/material.dart';

class AIMentorSettingsPage extends StatefulWidget {
  const AIMentorSettingsPage({super.key});

  @override
  State<AIMentorSettingsPage> createState() => _AIMentorSettingsPageState();
}

class _AIMentorSettingsPageState extends State<AIMentorSettingsPage> {
  bool _enableAutoContext = true;
  bool _enableVoicePlayback = false;
  bool _enableProactiveNudges = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Mentor Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Cross-Module Context Awareness'),
            subtitle: const Text('Allow AI Mentor to access Smart Planner & Finance summaries for personalized advice'),
            value: _enableAutoContext,
            onChanged: (val) => setState(() => _enableAutoContext = val),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Automatic Voice Playback'),
            subtitle: const Text('Read AI responses out loud automatically'),
            value: _enableVoicePlayback,
            onChanged: (val) => setState(() => _enableVoicePlayback = val),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Proactive Productivity Nudges'),
            subtitle: const Text('Receive timely study break & burnout prevention reminders'),
            value: _enableProactiveNudges,
            onChanged: (val) => setState(() => _enableProactiveNudges = val),
          ),
        ],
      ),
    );
  }
}
