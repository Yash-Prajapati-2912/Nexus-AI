import 'package:flutter/material.dart';

class ConversationDetailsPage extends StatelessWidget {
  const ConversationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Conversation Details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Conversation Info', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Title: Midterm Prep Strategy'),
                  const Text('Topic: Academic & Study'),
                  const Text('Created: July 26, 2026'),
                  const Text('Messages: 12'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.edit_rounded),
            title: const Text('Rename Conversation'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.push_pin_rounded),
            title: const Text('Pin to Top'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.archive_rounded),
            title: const Text('Archive Conversation'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
            title: const Text('Delete Conversation', style: TextStyle(color: Colors.redAccent)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
