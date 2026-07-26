import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../widgets/version_card.dart';
import '../widgets/preference_card.dart';

class AboutApplicationPage extends StatelessWidget {
  const AboutApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Nexus AI'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const VersionCard(
            appVersion: '1.0.0',
            buildNumber: '101',
          ),
          const SizedBox(height: 20),
          PreferenceCard(
            title: 'Legal & Compliance',
            subtitle: 'Licenses, Privacy Policy and Terms of Use',
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms & Conditions'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(RouteNames.settingsTerms),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.policy_outlined),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(RouteNames.settingsPrivacyPolicy),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.code_outlined),
                  title: const Text('Open Source Licenses'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(RouteNames.settingsOpenSourceLicenses),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.verified_user_outlined),
                  title: const Text('Software Licenses'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(RouteNames.settingsLicenses),
                ),
              ],
            ),
          ),
          PreferenceCard(
            title: 'Support & Feedback',
            subtitle: 'Contact engineers and submit requests',
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.support_agent_outlined),
                  title: const Text('Contact Support'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening Support Portal...')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bug_report_outlined),
                  title: const Text('Report a Bug'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bug Report dialog opened.')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lightbulb_outline),
                  title: const Text('Feature Request'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feature Request form opened.')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
