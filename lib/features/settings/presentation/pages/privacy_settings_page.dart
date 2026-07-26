import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/privacy_bloc.dart';
import '../bloc/privacy_event.dart';
import '../bloc/privacy_state.dart';
import '../widgets/preference_card.dart';
import '../widgets/switch_tile.dart';

class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Data'),
      ),
      body: BlocConsumer<PrivacyBloc, PrivacyState>(
        listener: (context, state) {
          if (state is PrivacyLoaded && state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.successMessage!)),
            );
          } else if (state is PrivacyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final privacy = (state is PrivacyLoaded) ? state.privacy : null;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              PreferenceCard(
                title: 'Data Collection & Telemetry',
                subtitle: 'Control how your app usage data is handled',
                child: Column(
                  children: [
                    SwitchTile(
                      icon: Icons.analytics_outlined,
                      title: 'Usage Analytics',
                      subtitle: 'Help improve features by sharing anonymous usage statistics',
                      value: privacy?.analyticsConsent ?? true,
                      onChanged: (val) => context.read<PrivacyBloc>().add(ToggleAnalyticsConsentEvent(val)),
                    ),
                    SwitchTile(
                      icon: Icons.bug_report_outlined,
                      title: 'Crash Reporting',
                      subtitle: 'Send crash logs to engineering team for rapid bug fixes',
                      value: privacy?.crashReportingConsent ?? true,
                      onChanged: (val) => context.read<PrivacyBloc>().add(ToggleCrashReportingEvent(val)),
                    ),
                    SwitchTile(
                      icon: Icons.psychology_outlined,
                      title: 'AI Training Consent',
                      subtitle: 'Allow anonymized prompt patterns for model fine-tuning',
                      value: privacy?.aiDataUsageConsent ?? true,
                      onChanged: (val) => context.read<PrivacyBloc>().add(ToggleAIDataUsageEvent(val)),
                    ),
                  ],
                ),
              ),
              PreferenceCard(
                title: 'Storage & History Cleanup',
                subtitle: 'Manage local data, cache, and conversation logs',
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.cleaning_services_outlined, color: Colors.orange),
                      title: const Text('Clear Application Cache'),
                      subtitle: const Text('Free up temporary image & document cache'),
                      trailing: ElevatedButton(
                        onPressed: () => context.read<PrivacyBloc>().add(ClearAppCacheEvent()),
                        child: const Text('Clear Cache'),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.forum_outlined, color: Colors.redAccent),
                      title: const Text('Delete AI Conversation History'),
                      subtitle: const Text('Permanently remove stored chat transcripts'),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                        onPressed: () => _confirmDeleteAIHistory(context),
                        child: const Text('Delete AI Data'),
                      ),
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

  void _confirmDeleteAIHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete AI History?'),
        content: const Text('This action is irreversible. All AI Mentor chat sessions will be erased permanently.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<PrivacyBloc>().add(DeleteAIHistoryEvent());
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
