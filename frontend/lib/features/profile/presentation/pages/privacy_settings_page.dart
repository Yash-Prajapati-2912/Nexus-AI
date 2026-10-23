import 'package:flutter/material.dart';
import '../widgets/preference_tile.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _publicProfile = true;
  bool _aiDataSharing = true;
  bool _analyticsConsent = true;
  bool _personalizedRecommendations = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & AI Consent Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PreferenceTile(
            title: 'Public Profile Visibility',
            subtitle: 'Allow other users to view your public badges & CGPA milestone achievements',
            value: _publicProfile,
            onChanged: (val) => setState(() => _publicProfile = val),
          ),
          const Divider(),
          PreferenceTile(
            title: 'AI Data Sharing & Personalization',
            subtitle: 'Allow AI Mentor & AI Advisor to access Smart Planner and Smart Finance summaries',
            value: _aiDataSharing,
            onChanged: (val) => setState(() => _aiDataSharing = val),
          ),
          const Divider(),
          PreferenceTile(
            title: 'Analytics Consent',
            subtitle: 'Share anonymous app usage telemetry to improve performance and stability',
            value: _analyticsConsent,
            onChanged: (val) => setState(() => _analyticsConsent = val),
          ),
          const Divider(),
          PreferenceTile(
            title: 'Personalized Recommendations',
            subtitle: 'Receive tailored study breaks, budget tips, and career milestones',
            value: _personalizedRecommendations,
            onChanged: (val) => setState(() => _personalizedRecommendations = val),
          ),
        ],
      ),
    );
  }
}
