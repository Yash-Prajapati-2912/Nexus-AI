import 'package:flutter/material.dart';
import '../widgets/about_card.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          AboutCard(
            title: '1. Information We Collect',
            content:
                'We collect user profile details, academic schedule items, financial ledger entries, and AI conversation context necessary to deliver AI recommendation features.',
          ),
          AboutCard(
            title: '2. Encryption & Data Protection',
            content:
                'All user data is encrypted in transit via TLS 1.3 and at rest using AES-256 encryption standards across backend PostgreSQL and local secure storage.',
          ),
          AboutCard(
            title: '3. Data Sharing & Third Parties',
            content:
                'Nexus AI does NOT sell user data or personal information to third parties or advertising networks. Telemetry data is completely anonymized.',
          ),
          AboutCard(
            title: '4. Your Privacy Rights',
            content:
                'You retain the right to export your complete data archive or permanently delete your account and AI history at any time from Settings.',
          ),
        ],
      ),
    );
  }
}
