import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/study_plan.dart';
import '../bloc/ai_planner_bloc.dart';
import '../bloc/ai_planner_event.dart';
import '../bloc/ai_planner_state.dart';
import '../widgets/study_plan_card.dart';

class SavedAIPlansPage extends StatelessWidget {
  const SavedAIPlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved AI Study Plans'),
      ),
      body: BlocBuilder<AIPlannerBloc, AIPlannerState>(
        builder: (context, state) {
          final saved = (state is AIPlannerLoadedState && state.savedPlans.isNotEmpty)
              ? state.savedPlans
              : [
                  StudyPlan(
                    id: 'saved-1',
                    title: 'Midterm Crunch 7-Day Plan',
                    summary: 'Intensive focus allocation for CS & Math exams.',
                    timeframe: 'weekly',
                    reasoning: ['Exams scheduled in 7 days.'],
                    actionItems: const [],
                    warnings: const [],
                    confidenceScore: 0.96,
                    providerName: 'GEMINI 1.5 PRO',
                    createdAt: DateTime.now().subtract(const Duration(days: 2)),
                    isSaved: true,
                  ),
                ];

          if (saved.isEmpty) {
            return const Center(child: Text('No saved AI plans yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: saved.length,
            itemBuilder: (context, index) {
              final plan = saved[index];
              return StudyPlanCard(
                plan: plan,
                onTap: () {
                  context.push(RouteNames.aiPlannerPlanDetails, extra: plan);
                },
                onDelete: () {
                  context.read<AIPlannerBloc>().add(DeletePlanEvent(plan.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Removed plan from saved list.')),
                  );
                },
                onShare: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sharing "${plan.title}" link...')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
