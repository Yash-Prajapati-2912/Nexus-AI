import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ai_finance_bloc.dart';
import '../bloc/ai_finance_state.dart';
import 'markdown_viewer.dart';
import 'typing_indicator.dart';

class MiniFinanceAssistantPanel extends StatefulWidget {
  const MiniFinanceAssistantPanel({super.key});

  @override
  State<MiniFinanceAssistantPanel> createState() => _MiniFinanceAssistantPanelState();
}

class _MiniFinanceAssistantPanelState extends State<MiniFinanceAssistantPanel> {
  final TextEditingController _inputController = TextEditingController();
  bool _isTyping = false;

  final List<Map<String, String>> _messages = [
    {
      'sender': 'AI',
      'text': 'Hi! I am your **AI Financial Advisor**. Ask me anything about your spending habits, budget limits, or savings targets!',
    },
  ];

  final List<String> _suggestedPrompts = [
    'How can I save ₹1,000 this month?',
    'Am I on track for my savings goal?',
    'What is my safe daily limit?',
  ];

  void _sendMessage(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      _messages.add({'sender': 'USER', 'text': query.trim()});
      _isTyping = true;
    });

    _inputController.clear();

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;

      String reply;
      try {
        final blocState = context.read<AIFinanceBloc>().state;
        if (blocState is AIFinanceLoadedState) {
          final q = query.toLowerCase();
          final limit = blocState.budgetRec.safeDailySpendingLimit;
          final savings = blocState.savingsRec.totalPotentialMonthlySavings;
          final topCategory = blocState.insight.highestCategories.isNotEmpty
              ? blocState.insight.highestCategories.first.categoryName
              : null;

          if (q.contains('daily') || q.contains('limit')) {
            reply = limit > 0
                ? 'Based on your active budget, your safe daily spending limit is **₹${limit.toStringAsFixed(2)}**.'
                : 'No active budget found. Set a monthly budget to calculate your safe daily spending limit.';
          } else if (q.contains('save') || q.contains('saving') || q.contains('goal')) {
            reply = savings > 0
                ? 'Based on your spending analysis, potential monthly savings of **₹${savings.toStringAsFixed(2)}** were identified.\n${blocState.savingsRec.aiStrategySummary}'
                : 'You currently have no savings optimization records. Add savings goals and expense records to identify potential monthly savings.';
          } else {
            reply = 'Financial Summary:\n'
                '- Safe Daily Limit: ${limit > 0 ? "₹${limit.toStringAsFixed(2)}" : "Not set"}\n'
                '- Top Expense Category: ${topCategory ?? "None recorded"}\n'
                '- AI Wellness: ${blocState.health.overallScore > 0 ? "${blocState.health.overallScore}/100" : "Data pending"}\n\n'
                '${blocState.health.summaryReasoning.isNotEmpty ? blocState.health.summaryReasoning : "Record more transactions to refine AI financial insights."}';
          }
        } else {
          reply = 'No confirmed financial transactions available. Add income, expenses, and budgets to get real-time AI assistance.';
        }
      } catch (_) {
        reply = 'Unable to fetch financial data right now. Please verify your finance entries.';
      }

      setState(() {
        _isTyping = false;
        _messages.add({
          'sender': 'AI',
          'text': reply,
        });
      });
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: Color(0xFF6366F1), size: 22),
                const SizedBox(width: 8),
                Text(
                  'AI Finance Assistant',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (_isTyping) ...[
                  const SizedBox(width: 8),
                  const TypingIndicator(),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxHeight: 220),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg['sender'] == 'USER';

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: isUser
                          ? Text(msg['text']!, style: const TextStyle(color: Colors.white))
                          : MarkdownViewer(content: msg['text']!),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _suggestedPrompts
                    .map((prompt) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ActionChip(
                            label: Text(prompt, style: const TextStyle(fontSize: 11)),
                            onPressed: () => _sendMessage(prompt),
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: const InputDecoration(
                      hintText: 'Ask AI financial question...',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.send_rounded, size: 18),
                  onPressed: () => _sendMessage(_inputController.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
