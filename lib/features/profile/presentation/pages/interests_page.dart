import 'package:flutter/material.dart';

class InterestsPage extends StatelessWidget {
  const InterestsPage({super.key});

  final List<String> _interests = const [
    'AI Software Architecture',
    'Machine Learning Engineering',
    'Mobile Application Performance',
    'Open Source Contribution',
    'Personal Finance & Wealth Building',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Career & Learning Interests')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _interests
              .map((item) => Chip(
                    avatar: const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                    label: Text(item, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
