import 'package:flutter/material.dart';
import '../../../../config/constants/storage_keys.dart';
import '../../../../core/storage/preferences_manager.dart';
import '../../../../di/injection_container.dart';

class AIMentorSettingsPage extends StatefulWidget {
  const AIMentorSettingsPage({super.key});

  @override
  State<AIMentorSettingsPage> createState() => _AIMentorSettingsPageState();
}

class _AIMentorSettingsPageState extends State<AIMentorSettingsPage> {
  bool _enableAutoContext = true;
  bool _enableProactiveNudges = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() {
    try {
      final prefs = getIt<PreferencesManager>();
      setState(() {
        _enableAutoContext = prefs.getBool(StorageKeys.aiMentorAutoContext, defaultValue: true);
        _enableProactiveNudges = prefs.getBool(StorageKeys.aiMentorProactiveNudges, defaultValue: true);
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateSetting(String key, bool newValue, void Function(bool) rollback) async {
    try {
      final prefs = getIt<PreferencesManager>();
      final success = await prefs.setBool(key, newValue);
      if (!mounted) return;

      if (!success) {
        setState(() => rollback(!newValue));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save preference. Please try again.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preference saved.'),
            duration: Duration(milliseconds: 1500),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => rollback(!newValue));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving preference: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Mentor Settings')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SwitchListTile(
                  title: const Text('Cross-Module Context Awareness'),
                  subtitle: const Text('Allow AI Mentor to access Smart Planner & Finance summaries for personalized advice'),
                  value: _enableAutoContext,
                  onChanged: (val) {
                    setState(() => _enableAutoContext = val);
                    _updateSetting(
                      StorageKeys.aiMentorAutoContext,
                      val,
                      (prev) => _enableAutoContext = prev,
                    );
                  },
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Proactive Productivity Nudges'),
                  subtitle: const Text('Receive timely study break & burnout prevention reminders'),
                  value: _enableProactiveNudges,
                  onChanged: (val) {
                    setState(() => _enableProactiveNudges = val);
                    _updateSetting(
                      StorageKeys.aiMentorProactiveNudges,
                      val,
                      (prev) => _enableProactiveNudges = prev,
                    );
                  },
                ),
              ],
            ),
    );
  }
}
