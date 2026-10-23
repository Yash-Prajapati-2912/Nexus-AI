import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/recommendation.dart';
import '../bloc/ai_planner_bloc.dart';
import '../bloc/ai_planner_event.dart';
import '../bloc/ai_planner_state.dart';
import '../widgets/ai_skeleton_loader.dart';
import '../widgets/recommendation_card.dart';

class StudyRecommendationsPage extends StatefulWidget {
  const StudyRecommendationsPage({super.key});

  @override
  State<StudyRecommendationsPage> createState() => _StudyRecommendationsPageState();
}

class _StudyRecommendationsPageState extends State<StudyRecommendationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AIPlannerBloc>().add(const LoadRecommendationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Recommendations'),
      ),

      body: BlocBuilder<AIPlannerBloc, AIPlannerState>(
        builder: (context, state) {
          if (state is AIPlannerLoadingState) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: AISkeletonLoader(height: 200),
            );
          }

          final recs = (state is AIPlannerLoadedState && state.recommendations.isNotEmpty)
              ? state.recommendations
              : const [
                  Recommendation(
                    id: 'rec-1',
                    title: 'Recommended Study Time: 08:00 AM',
                    description: 'Schedule your hardest problem sets early when cognitive focus peaks.',
                    priority: 'HIGH',
                    category: 'STUDY_TIME',
                  ),
                  Recommendation(
                    id: 'rec-2',
                    title: 'Pomodoro 50/10 Break Pattern',
                    description: 'Take a 10-minute walk after 50 minutes of deep programming work.',
                    priority: 'HIGH',
                    category: 'BREAK',
                  ),
                  Recommendation(
                    id: 'rec-3',
                    title: 'Elevate Computer Science Priority',
                    description: 'Reorder CS assignment draft before math prep due to deadline proximity.',
                    priority: 'MEDIUM',
                    category: 'SUBJECT_PRIORITY',
                  ),
                  Recommendation(
                    id: 'rec-4',
                    title: 'Feynman Technique for Physics',
                    description: 'Explain Thermodynamics concepts in simple terms to identify knowledge gaps.',
                    priority: 'LOW',
                    category: 'TECHNIQUE',
                  ),
                ];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recs.length,
            itemBuilder: (context, index) {
              final rec = recs[index];
              return RecommendationCard(
                recommendation: rec,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Applied recommendation: ${rec.title}')),
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
