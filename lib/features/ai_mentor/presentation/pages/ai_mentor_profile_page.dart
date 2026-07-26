import 'package:flutter/material.dart';

class AIMentorProfilePage extends StatelessWidget {
  const AIMentorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Mentor Persona')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 44,
              backgroundColor: Color(0xFF6366F1),
              child: Icon(Icons.auto_awesome, size: 44, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text('Nexus AI Student Mentor', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Persona: Supportive, Academic & Financial Coach', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 20),
            const Card(
              child: ListTile(
                leading: Icon(Icons.psychology_rounded, color: Color(0xFF6366F1)),
                title: Text('Tone of Voice'),
                subtitle: Text('Encouraging, Structured, Data-Driven'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
