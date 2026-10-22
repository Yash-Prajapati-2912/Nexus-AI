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
                  subtitle: const Text('Get help from the Nexus AI engineering team'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Contact Support'),
                        content: const Text(
                          'For questions, account help, and technical support, please reach out to us at:\n\nsupport@nexusai.com',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bug_report_outlined),
                  title: const Text('Report a Bug'),
                  subtitle: const Text('Submit diagnostic logs and issue descriptions'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Report a Bug'),
                        content: const Text(
                          'To report bugs or unexpected crashes, please send reproduction steps and logs to:\n\nbugs@nexusai.com\n\nOr file an issue in our repository tracker.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lightbulb_outline),
                  title: const Text('Feature Request'),
                  subtitle: const Text('Share ideas for future platform capabilities'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Feature Request'),
                        content: const Text(
                          'We are actively developing Nexus AI! Email your feature suggestions and ideas to:\n\nfeedback@nexusai.com',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
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
