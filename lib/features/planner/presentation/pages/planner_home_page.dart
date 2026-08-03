import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/design_system/widgets/empty_states/specialized_empty_states.dart';
import '../../../../shared/design_system/widgets/error_states/app_error_card.dart';
import '../../../../shared/design_system/widgets/loaders/shimmer_loader.dart';
import '../../../../shared/widgets/base_scaffold.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../../../../theme/design_tokens/radius.dart';
import '../bloc/planner_bloc.dart';
import '../bloc/planner_event.dart';
import '../bloc/planner_state.dart';
import '../widgets/task_card.dart';
import 'create_task_page.dart';

class PlannerHomePage extends StatefulWidget {
  const PlannerHomePage({super.key});

  @override
  State<PlannerHomePage> createState() => _PlannerHomePageState();
}

class _PlannerHomePageState extends State<PlannerHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<PlannerBloc>().add(LoadPlannerEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;

    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Smart Planner', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<PlannerBloc>().add(LoadPlannerEvent()),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: DesignRadius.full,
          gradient: isDark ? DesignColors.primaryGradientDark : DesignColors.primaryGradientLight,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () async {
            final bloc = context.read<PlannerBloc>();
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CreateTaskPage()),
            );
            bloc.add(LoadPlannerEvent());
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            'New Task',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
      body: BlocBuilder<PlannerBloc, PlannerState>(
        builder: (context, state) {
          if (state is PlannerLoadingState || state is PlannerInitialState) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ShimmerLoader(width: double.infinity, height: 60),
                  SizedBox(height: 12),
                  ShimmerLoader(width: double.infinity, height: 60),
                  SizedBox(height: 12),
                  ShimmerLoader(width: double.infinity, height: 60),
                ],
              ),
            );
          }

          if (state is PlannerErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: AppErrorCard(
                  message: state.message,
                  onRetry: () => context.read<PlannerBloc>().add(LoadPlannerEvent()),
                ),
              ),
            );
          }

          final tasks = (state as PlannerLoadedState).tasks;

          if (tasks.isEmpty) {
            return NoTasksEmptyState(
              onAddTask: () async {
                final bloc = context.read<PlannerBloc>();
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreateTaskPage()),
                );
                bloc.add(LoadPlannerEvent());
              },
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(
                task: task,
                onToggle: (val) {
                  context.read<PlannerBloc>().add(ToggleTaskCompletionEvent(task.id));
                },
                onDelete: () {
                  context.read<PlannerBloc>().add(DeleteTaskEvent(task.id));
                },
              );
            },
          );
        },
      ),
    );
  }
}

