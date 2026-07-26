import 'package:flutter/material.dart';
import '../widgets/about_card.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          AboutCard(
            title: '1. Acceptance of Terms',
            content:
                'By accessing or using the Nexus AI Student Life Operating System, you agree to comply with and be bound by these Terms and Conditions. Please review them carefully.',
          ),
          AboutCard(
            title: '2. User Accounts & Security',
            content:
                'Users are responsible for maintaining the confidentiality of their credentials, multi-factor tokens, and biometric security keys. Nexus AI assumes no liability for unauthorized access resulting from user negligence.',
          ),
          AboutCard(
            title: '3. Intellectual Property',
            content:
                'All proprietary algorithms, UI components, AI prompts, and software codebases within Nexus AI are the exclusive property of Nexus AI Technologies.',
          ),
          AboutCard(
            title: '4. Limitation of Liability',
            content:
                'Nexus AI is provided "as is" without express warranties. In no event shall Nexus AI be liable for direct, indirect, or incidental damages arising out of software usage.',
          ),
        ],
      ),
    );
  }
}
