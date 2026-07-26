import 'package:flutter/material.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  final List<String> _skills = const [
    'Flutter & Dart',
    'TypeScript & NestJS',
    'Python & PyTorch',
    'Data Structures & Algorithms',
    'PostgreSQL & TypeORM',
    'Docker & CI/CD Pipelines',
    'Clean Architecture & SOLID',
    'System Design Frameworks',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Academic & Technical Skills')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _skills
              .map((skill) => Chip(
                    avatar: const Icon(Icons.code_rounded, size: 16),
                    label: Text(skill, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
