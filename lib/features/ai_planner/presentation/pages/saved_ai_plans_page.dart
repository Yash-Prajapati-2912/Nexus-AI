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
          final saved = (state is AIPlannerLoadedState) ? state.savedPlans : <StudyPlan>[];

          if (saved.isEmpty) {
            final theme = Theme.of(context);
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.bookmark_border_rounded, size: 36, color: theme.colorScheme.outline),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Saved AI Plans Yet',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Generated study plans you save will appear here for future reference.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            );
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
              );
            },
          );
        },
      ),
    );
  }
}
