import 'package:flutter/material.dart';
import '../../domain/entities/prompt_template.dart';

class PromptChip extends StatelessWidget {
  final PromptTemplate prompt;
  final VoidCallback onTap;

  const PromptChip({super.key, required this.prompt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF6366F1)),
      label: Text(prompt.title, style: const TextStyle(fontSize: 12)),
      onPressed: onTap,
    );
  }
}
