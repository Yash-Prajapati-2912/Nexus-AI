import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/design_system/widgets/empty_states/specialized_empty_states.dart';
import '../../../../shared/design_system/widgets/error_states/app_error_card.dart';
import '../../../../shared/design_system/widgets/loaders/shimmer_loader.dart';
import '../../../../shared/widgets/base_scaffold.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../../../../theme/design_tokens/radius.dart';
import '../../domain/entities/task_entity.dart';
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

  // Get canonical top level category for grouping
  String _getTopCategoryName(TaskEntity task) {
    final docType = task.documentType.toUpperCase();
    final rawCat = task.topLevelCategory;
    final lower = rawCat.toLowerCase();

    if (docType == 'SYLLABUS' || docType == 'QUESTION_BANK' || docType == 'EXAM_MATERIAL' || lower.contains('exam') || lower.contains('preparation')) {
      return 'Exam Preparation';
    } else if (docType == 'NOTES' || docType == 'LECTURE_MATERIAL' || docType == 'STUDY_GUIDE' || lower.contains('study')) {
      return 'Study Materials';
    } else if (docType == 'PROJECT' || docType == 'LAB_PRACTICAL' || lower.contains('project')) {
      return 'Projects';
    } else if (docType == 'PRACTICAL' || docType == 'LAB_MANUAL' || lower.contains('practical') || lower.contains('lab')) {
      return 'Practical & Lab';
    } else if (docType == 'ASSIGNMENT' || docType == 'ASSIGNMENT_COLLECTION' || lower.contains('assignment') || lower.contains('coursework')) {
      return 'Assignments & Coursework';
    }
    return rawCat.isNotEmpty ? rawCat : 'Other';
  }

  // Get color per top-level category
  Color _getCategoryColor(String topCat) {
    switch (topCat) {
      case 'Assignments & Coursework':
        return Colors.blueAccent;
      case 'Exam Preparation':
        return Colors.orangeAccent;
      case 'Study Materials':
        return Colors.indigoAccent;
      case 'Projects':
        return Colors.purpleAccent;
      case 'Practical & Lab':
        return Colors.cyanAccent;
      case 'Other':
      default:
        return Colors.tealAccent;
    }
  }

  IconData _getCategoryIcon(String topCat) {
    switch (topCat) {
      case 'Assignments & Coursework':
        return Icons.assignment_outlined;
      case 'Exam Preparation':
        return Icons.quiz_outlined;
      case 'Study Materials':
        return Icons.menu_book_outlined;
      case 'Projects':
        return Icons.code_rounded;
      case 'Practical & Lab':
        return Icons.biotech_outlined;
      case 'Other':
      default:
        return Icons.school_outlined;
    }
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
            icon: const Icon(Icons.cleaning_services_rounded, color: Colors.orangeAccent),
            tooltip: 'Purge / Reset EEJS Tasks for Re-Test',
            onPressed: () {
              final state = context.read<PlannerBloc>().state;
              if (state is PlannerLoadedState) {
                final eejsTasks = state.tasks.where((t) =>
                    t.title.contains('11ASSIGNMENT') ||
                    t.title.contains('1010343482') ||
                    t.subject.toLowerCase().contains('eejs') ||
                    t.title.toLowerCase().contains('eejs')).toList();

                for (final t in eejsTasks) {
                  context.read<PlannerBloc>().add(DeleteTaskEvent(t.id));
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('🧹 Cleared ${eejsTasks.length} EEJS task(s) for clean re-test!')),
                );
              }
            },
          ),
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
              color: primaryColor.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () async {
            final bloc = context.read<PlannerBloc>();
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: bloc,
                  child: const CreateTaskPage(),
                ),
              ),
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
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: bloc,
                      child: const CreateTaskPage(),
                    ),
                  ),
                );
                bloc.add(LoadPlannerEvent());
              },
            );
          }

          // Build hierarchical mapping: TopCategory -> Subject -> List<TaskEntity>
          final Map<String, Map<String, List<TaskEntity>>> hierarchy = {
            'Assignments & Coursework': {},
            'Exam Preparation': {},
            'Study Materials': {},
            'Projects': {},
            'Other Academic': {},
          };

          for (final task in tasks) {
            final topCat = _getTopCategoryName(task);
            final subject = task.subject;

            if (!hierarchy.containsKey(topCat)) {
              hierarchy[topCat] = {};
            }
            if (!hierarchy[topCat]!.containsKey(subject)) {
              hierarchy[topCat]![subject] = [];
            }
            hierarchy[topCat]![subject]!.add(task);
          }

          return ListView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
            children: hierarchy.entries.where((e) => e.value.isNotEmpty).map((topEntry) {
              final topCatName = topEntry.key;
              final subjectMap = topEntry.value;
              final catColor = _getCategoryColor(topCatName);
              final totalTasks = subjectMap.values.fold<int>(0, (sum, list) => sum + list.length);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: catColor.withValues(alpha: 0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    leading: CircleAvatar(
                      backgroundColor: catColor.withValues(alpha: 0.15),
                      child: Icon(_getCategoryIcon(topCatName), color: catColor, size: 20),
                    ),
                    title: Text(
                      topCatName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      '${subjectMap.length} ${subjectMap.length == 1 ? "Subject" : "Subjects"} • $totalTasks ${totalTasks == 1 ? "Item" : "Items"}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    children: subjectMap.entries.map((subEntry) {
                      final subjectName = subEntry.key;
                      final subjectTasks = subEntry.value;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.bookmark_outline, size: 16, color: Colors.indigoAccent),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    subjectName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black87,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: catColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${subjectTasks.length}',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: catColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...subjectTasks.map((task) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: TaskCard(
                                    task: task,
                                    onToggle: (val) => context.read<PlannerBloc>().add(ToggleTaskCompletionEvent(task.id)),
                                    onDelete: () => context.read<PlannerBloc>().add(DeleteTaskEvent(task.id)),
                                  ),
                                )),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

