import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/design_system/widgets/empty_states/specialized_empty_states.dart';
import '../../../../shared/design_system/widgets/error_states/app_error_card.dart';
import '../../../../shared/design_system/widgets/loaders/shimmer_loader.dart';
import '../../../../shared/widgets/base_scaffold.dart';
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
  String _searchQuery = '';
  String _selectedFilter = 'ALL'; // ALL, TODAY, UPCOMING, HIGH_PRIORITY, COMPLETED, or category name
  String _viewMode = 'TREE'; // TREE or TIMELINE

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

  Future<void> _openCreateTaskPage() async {
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
  }

  List<TaskEntity> _applyFilter(List<TaskEntity> tasks) {
    var result = tasks;

    // Search query filter
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      result = result.where((t) {
        return t.title.toLowerCase().contains(q) ||
            t.subject.toLowerCase().contains(q) ||
            t.topLevelCategory.toLowerCase().contains(q) ||
            (t.description != null && t.description!.toLowerCase().contains(q));
      }).toList();
    }

    // Category / Status / Priority chip filter
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_selectedFilter == 'TODAY') {
      result = result.where((t) {
        final d = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
        return d.isAtSameMomentAs(today) && t.status != TaskStatus.completed;
      }).toList();
    } else if (_selectedFilter == 'UPCOMING') {
      result = result.where((t) {
        final d = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
        return d.isAfter(today) && t.status != TaskStatus.completed;
      }).toList();
    } else if (_selectedFilter == 'HIGH_PRIORITY') {
      result = result.where((t) {
        return (t.priority == TaskPriority.high || t.priority == TaskPriority.urgent) &&
            t.status != TaskStatus.completed;
      }).toList();
    } else if (_selectedFilter == 'COMPLETED') {
      result = result.where((t) => t.status == TaskStatus.completed).toList();
    } else if (_selectedFilter != 'ALL') {
      result = result.where((t) => _getTopCategoryName(t) == _selectedFilter).toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseScaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Smart Planner', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Poppins')),
                const SizedBox(width: 6),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
                  ).createShader(bounds),
                  child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
                ),
              ],
            ),
            const Text(
              'Your academic workload, organized intelligently.',
              style: TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'Poppins'),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF7C6CFF)),
            tooltip: 'Add Task / PDF',
            onPressed: _openCreateTaskPage,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<PlannerBloc>().add(LoadPlannerEvent()),
            tooltip: 'Refresh Tasks',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateTaskPage,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add Task',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Poppins'),
        ),
        backgroundColor: const Color(0xFF7C6CFF),
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

          final allTasks = (state as PlannerLoadedState).tasks;

          if (allTasks.isEmpty) {
            return NoTasksEmptyState(
              onAddTask: _openCreateTaskPage,
            );
          }

          final filteredTasks = _applyFilter(allTasks);

          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 800;

              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : double.infinity),
                  child: _buildPlannerMainContent(context, allTasks, filteredTasks, isDark, isDesktop: isDesktop),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPlannerMainContent(
    BuildContext context,
    List<TaskEntity> allTasks,
    List<TaskEntity> filteredTasks,
    bool isDark, {
    required bool isDesktop,
  }) {
    // Calculate REAL metric counts
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayCount = allTasks.where((t) {
      final d = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
      return d.isAtSameMomentAs(today) && t.status != TaskStatus.completed;
    }).length;

    final upcomingCount = allTasks.where((t) {
      final d = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
      return d.isAfter(today) && t.status != TaskStatus.completed;
    }).length;

    final highPriorityCount = allTasks.where((t) {
      return (t.priority == TaskPriority.high || t.priority == TaskPriority.urgent) &&
          t.status != TaskStatus.completed;
    }).length;

    final completedCount = allTasks.where((t) => t.status == TaskStatus.completed).length;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Integrated Search & Filter Chips Bar
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search tasks by title, subject or category...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(icon: const Icon(Icons.clear_rounded, size: 18), onPressed: () => setState(() => _searchQuery = ''))
                  : null,
              filled: true,
              fillColor: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),

          // Filter Chips Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildFilterChip('All (${allTasks.length})', 'ALL'),
                _buildFilterChip('Today ($todayCount)', 'TODAY'),
                _buildFilterChip('Upcoming ($upcomingCount)', 'UPCOMING'),
                _buildFilterChip('High Priority ($highPriorityCount)', 'HIGH_PRIORITY'),
                _buildFilterChip('Completed ($completedCount)', 'COMPLETED'),
                _buildFilterChip('Assignments', 'Assignments & Coursework'),
                _buildFilterChip('Exam Prep', 'Exam Preparation'),
                _buildFilterChip('Study Materials', 'Study Materials'),
                _buildFilterChip('Projects', 'Projects'),
                _buildFilterChip('Practical & Lab', 'Practical & Lab'),
                _buildFilterChip('Other', 'Other'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // View Mode Toggle (Tree vs Timeline)
          Align(
            alignment: Alignment.centerRight,
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'TREE', icon: Icon(Icons.account_tree_outlined, size: 15), label: Text('Tree', style: TextStyle(fontSize: 11, fontFamily: 'Poppins'))),
                ButtonSegment(value: 'TIMELINE', icon: Icon(Icons.view_timeline_outlined, size: 15), label: Text('Timeline', style: TextStyle(fontSize: 11, fontFamily: 'Poppins'))),
              ],
              selected: {_viewMode},
              onSelectionChanged: (set) => setState(() => _viewMode = set.first),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return isDark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5);
                  }
                  return isDark ? const Color(0xFF1E293B) : Colors.grey.shade100;
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return isDark ? Colors.white70 : Colors.black87;
                }),
                side: WidgetStateProperty.all(
                  BorderSide(color: isDark ? Colors.white10 : Colors.black12),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Render Selected View (Hierarchy Tree vs Timeline)
          if (filteredTasks.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(Icons.inbox_rounded, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  const Text('No tasks match your filter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Poppins')),
                  const SizedBox(height: 4),
                  const Text('Try clearing search or choosing another filter.', style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins')),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => setState(() {
                      _searchQuery = '';
                      _selectedFilter = 'ALL';
                    }),
                    icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
                    label: const Text('Reset Filters'),
                  ),
                ],
              ),
            )
          else if (_viewMode == 'TREE')
            _buildCategoryTreeView(context, filteredTasks, isDark, isDesktop: isDesktop)
          else
            _buildTimelineView(context, filteredTasks, isDark, isDesktop: isDesktop),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() => _selectedFilter = value);
          }
        },
        selectedColor: Colors.indigoAccent,
        labelStyle: TextStyle(color: isSelected ? Colors.white : null),
      ),
    );
  }

  // Section 3 & 4: CATEGORY TREE HIERARCHY
  Widget _buildCategoryTreeView(BuildContext context, List<TaskEntity> tasks, bool isDark, {required bool isDesktop}) {
    final Map<String, Map<String, List<TaskEntity>>> hierarchy = {
      'Assignments & Coursework': {},
      'Exam Preparation': {},
      'Study Materials': {},
      'Projects': {},
      'Practical & Lab': {},
      'Other': {},
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

    return Column(
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
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
              subtitle: Text(
                '${subjectMap.length} ${subjectMap.length == 1 ? "Subject" : "Subjects"} • $totalTasks ${totalTasks == 1 ? "Item" : "Items"}',
                style: const TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'Poppins'),
              ),
              children: subjectMap.entries.map((subEntry) {
                final subjectName = subEntry.key;
                final subjectTasks = subEntry.value;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.bookmark_outline_rounded, size: 16, color: Colors.indigoAccent),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              subjectName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isDark ? Colors.white70 : Colors.black87,
                                fontFamily: 'Poppins',
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
                              onTap: () => context.push('${RouteNames.plannerTaskDetail}?id=${task.id}'),
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
  }

  // Section 2: TIMELINE VIEW (Today / Up Next / Later / Completed)
  Widget _buildTimelineView(BuildContext context, List<TaskEntity> tasks, bool isDark, {required bool isDesktop}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextWeek = today.add(const Duration(days: 7));

    final todayTasks = tasks.where((t) {
      final d = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
      return d.isAtSameMomentAs(today) && t.status != TaskStatus.completed;
    }).toList();

    final upNextTasks = tasks.where((t) {
      final d = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
      return d.isAfter(today) && d.isBefore(nextWeek) && t.status != TaskStatus.completed;
    }).toList();

    final laterTasks = tasks.where((t) {
      final d = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
      return !d.isBefore(nextWeek) && t.status != TaskStatus.completed;
    }).toList();

    final completedTasks = tasks.where((t) => t.status == TaskStatus.completed).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (todayTasks.isNotEmpty) _buildTimelineSection('TODAY', todayTasks, Colors.blueAccent, isDark, isDesktop: isDesktop),
        if (upNextTasks.isNotEmpty) _buildTimelineSection('UP NEXT (THIS WEEK)', upNextTasks, Colors.indigoAccent, isDark, isDesktop: isDesktop),
        if (laterTasks.isNotEmpty) _buildTimelineSection('LATER', laterTasks, Colors.purpleAccent, isDark, isDesktop: isDesktop),
        if (completedTasks.isNotEmpty) _buildTimelineSection('COMPLETED', completedTasks, Colors.greenAccent, isDark, isDesktop: isDesktop),
      ],
    );
  }

  Widget _buildTimelineSection(String title, List<TaskEntity> taskList, Color accentColor, bool isDark, {required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 8, height: 16, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(4))),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: accentColor,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
              child: Text('${taskList.length}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: accentColor)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...taskList.map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TaskCard(
                task: t,
                onToggle: (val) => context.read<PlannerBloc>().add(ToggleTaskCompletionEvent(t.id)),
                onDelete: () => context.read<PlannerBloc>().add(DeleteTaskEvent(t.id)),
                onTap: () => context.push('${RouteNames.plannerTaskDetail}?id=${t.id}'),
              ),
            )),
        const SizedBox(height: 16),
      ],
    );
  }
}
