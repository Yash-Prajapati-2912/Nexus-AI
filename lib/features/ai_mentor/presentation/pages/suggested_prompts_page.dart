import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/prompt_template.dart';
import '../bloc/prompt_bloc.dart';

class SuggestedPromptsPage extends StatelessWidget {
  final String? conversationId;

  const SuggestedPromptsPage({super.key, this.conversationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suggested Prompts Library')),
      body: BlocBuilder<PromptBloc, PromptState>(
        builder: (context, state) {
          if (state is PromptLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6366F1)),
            );
          }

          if (state is PromptFailureState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    const Text(
                      'Failed to load suggested prompts',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<PromptBloc>().add(const LoadPromptsEvent()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final prompts = (state is PromptLoadedState) ? state.prompts : <PromptTemplate>[];

          if (prompts.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, size: 48, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'No suggested prompts available',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: prompts.length,
            itemBuilder: (context, index) {
              final p = prompts[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.auto_awesome, color: Color(0xFF6366F1)),
                  title: Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${p.category} • ${p.promptText}'),
                  onTap: () {
                    final queryParams = <String, String>{
                      'prompt': p.promptText,
                      if (p.category.isNotEmpty) 'topic': p.category,
                    };
                    if (conversationId != null &&
                        conversationId!.isNotEmpty &&
                        conversationId != 'c_new') {
                      queryParams['id'] = conversationId!;
                    }
                    final uri = Uri(
                      path: RouteNames.aiMentorConversation,
                      queryParameters: queryParams,
                    );
                    context.push(uri.toString());
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

