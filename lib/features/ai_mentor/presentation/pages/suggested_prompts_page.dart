import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/prompt_template.dart';

class SuggestedPromptsPage extends StatelessWidget {
  const SuggestedPromptsPage({super.key});

  final List<PromptTemplate> _prompts = const [
    PromptTemplate(id: 'p1', title: 'Exam Prep Strategy', category: 'STUDY', promptText: 'Structure my revision for upcoming midterms.'),
    PromptTemplate(id: 'p2', title: 'Monthly Budget Audit', category: 'FINANCE', promptText: 'Analyze my dining expenses and save \$50/month.'),
    PromptTemplate(id: 'p3', title: 'Placement Readiness', category: 'CAREER', promptText: 'What technical skills should I highlight on my resume?'),
    PromptTemplate(id: 'p4', title: 'Burnout Prevention', category: 'PRODUCTIVITY', promptText: 'Give me a 15-minute daily study break framework.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suggested Prompts Library')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _prompts.length,
        itemBuilder: (context, index) {
          final p = _prompts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.auto_awesome, color: Color(0xFF6366F1)),
              title: Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${p.category} • ${p.promptText}'),
              onTap: () => context.push('${RouteNames.aiMentorConversation}?prompt=${Uri.encodeComponent(p.promptText)}'),
            ),
          );
        },
      ),
    );
  }
}
