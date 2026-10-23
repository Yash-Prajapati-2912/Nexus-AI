import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../bloc/profile_bloc.dart';

class GoalsOverviewPage extends StatelessWidget {
  const GoalsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Goals Overview')),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is! ProfileLoadedState) {
            return const Center(child: CircularProgressIndicator());
          }

          final prefs = state.preferences;
          final goals = [
            if (prefs.productivityGoals.trim().isNotEmpty)
              _GoalItem(title: prefs.productivityGoals, category: 'Productivity Goal'),
            if (prefs.financialGoals.trim().isNotEmpty)
              _GoalItem(title: prefs.financialGoals, category: 'Financial Goal'),
            if (prefs.careerGoals.trim().isNotEmpty)
              _GoalItem(title: prefs.careerGoals, category: 'Career Goal'),
          ];

          if (goals.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      size: 64,
                      color: isDark ? Colors.white38 : Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Active Goals Set',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your productivity, financial, or career goals to track your milestone progress!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => context.push(RouteNames.profileEdit),
                      icon: const Icon(Icons.edit_rounded, size: 18),
                      label: const Text('Update Profile Info'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              return _GoalTile(title: goal.title, category: goal.category);
            },
          );
        },
      ),
    );
  }
}

class _GoalItem {
  final String title;
  final String category;
  const _GoalItem({required this.title, required this.category});
}

class _GoalTile extends StatelessWidget {
  final String title;
  final String category;

  const _GoalTile({required this.title, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.stars_rounded, color: Color(0xFF10B981), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(category, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.secondary)),
          ],
        ),
      ),
    );
  }
}
