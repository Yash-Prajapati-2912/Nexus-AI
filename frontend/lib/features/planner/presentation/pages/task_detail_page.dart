import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/base_scaffold.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/planner_bloc.dart';
import '../bloc/planner_event.dart';
import '../bloc/planner_state.dart';
import '../widgets/priority_badge.dart';
import '../widgets/status_badge.dart';

class TaskDetailPage extends StatefulWidget {
  final String? taskId;

  const TaskDetailPage({super.key, this.taskId});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late List<String> _subtasks;
  late List<bool> _subtaskChecked;
  String? _loadedTaskId;

  void _initSubtasks(TaskEntity task) {
    if (_loadedTaskId != task.id) {
      _loadedTaskId = task.id;
      _subtasks = List<String>.from(task.subtasks ?? []);
      _subtaskChecked = List<bool>.filled(_subtasks.length, false);
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final diff = due.difference(today).inDays;

    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final monthName = months[dueDate.month - 1];
    final dateStr = '$monthName ${dueDate.day}, ${dueDate.year}';

    if (diff == 0) {
      return '$dateStr (Due Today)';
    } else if (diff > 0) {
      return '$dateStr ($diff ${diff == 1 ? "day" : "days"} remaining)';
    } else {
      return '$dateStr (Overdue by ${diff.abs()} ${diff.abs() == 1 ? "day" : "days"})';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseScaffold(
      body: BlocBuilder<PlannerBloc, PlannerState>(
        builder: (context, state) {
          if (state is PlannerLoadingState || state is PlannerInitialState) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6366F1)),
            );
          }

          if (state is PlannerErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load task details',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(state.message, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context.read<PlannerBloc>().add(LoadPlannerEvent()),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Back to Planner'),
                    ),
                  ],
                ),
              ),
            );
          }

          final tasks = (state as PlannerLoadedState).tasks;
          final task = tasks.firstWhere(
            (t) => t.id == widget.taskId,
            orElse: () => tasks.isNotEmpty
                ? tasks.first
                : TaskEntity(
                    id: 'unknown',
                    title: 'Task Not Found',
                    dueDate: DateTime.now(),
                    priority: TaskPriority.medium,
                    status: TaskStatus.pending,
                    category: 'Planner',
                  ),
          );

          if (task.id == 'unknown') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.task_alt_rounded, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Task Not Found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Back to Planner'),
                  ),
                ],
              ),
            );
          }

          _initSubtasks(task);

          final isCompleted = task.status == TaskStatus.completed;
          final topCat = task.topLevelCategory;
          final subject = task.subject;
          final docType = task.documentType;
          final descriptionText = task.description ?? task.whatWeAreGoingToDo;
          final priorityReason = task.priorityReasoning ?? task.whyThisTaskExists;
          final timeEstimate = task.timeAllocationHint;
          final requirements = task.requirements ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Navigation / Breadcrumb Row
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/planner');
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            child: Row(
                              children: [
                                Icon(Icons.arrow_back_rounded, size: 18, color: Color(0xFF818CF8)),
                                SizedBox(width: 6),
                                Text(
                                  'Back to Planner',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF818CF8),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '/',
                          style: TextStyle(color: isDark ? Colors.white30 : Colors.black26),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '$topCat • $subject',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white60 : Colors.black54,
                              fontFamily: 'Poppins',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Header Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badges Row
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              StatusBadge(status: task.status),
                              PriorityBadge(priority: task.priority),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.indigo.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  '$topCat • $docType',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigoAccent,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.event_rounded, size: 13, color: Colors.orangeAccent),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatDueDate(task.dueDate),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orangeAccent,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Title
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                              fontFamily: 'Poppins',
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Subject: $subject',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white60 : Colors.black54,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Action Buttons
                          Wrap(
                            spacing: 12,
                            runSpacing: 10,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  context.read<PlannerBloc>().add(ToggleTaskCompletionEvent(task.id));
                                },
                                icon: Icon(
                                  isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                  size: 18,
                                ),
                                label: Text(isCompleted ? 'Completed' : 'Mark as Complete'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isCompleted ? const Color(0xFF10B981) : const Color(0xFF6366F1),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: () {
                                  context.read<PlannerBloc>().add(DeleteTaskEvent(task.id));
                                  context.pop();
                                },
                                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
                                label: const Text('Delete Task', style: TextStyle(color: Colors.redAccent)),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section 1: About this task
                    _buildSectionCard(
                      context,
                      title: 'About this task',
                      icon: Icons.description_rounded,
                      isDark: isDark,
                      child: Text(
                        (descriptionText != null && descriptionText.isNotEmpty)
                            ? descriptionText
                            : 'No additional description provided for this task.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 2: Requirements & Guidelines
                    if (requirements.isNotEmpty) ...[
                      _buildSectionCard(
                        context,
                        title: 'Requirements & Guidelines',
                        icon: Icons.fact_check_rounded,
                        isDark: isDark,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: requirements
                              .map(
                                (req) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.check_circle_outline_rounded, size: 16, color: Color(0xFF6366F1)),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          req,
                                          style: TextStyle(
                                            fontSize: 13,
                                            height: 1.4,
                                            color: isDark ? Colors.white70 : Colors.black87,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Section 3: Action Steps & Subtasks
                    if (_subtasks.isNotEmpty) ...[
                      _buildSectionCard(
                        context,
                        title: 'Action Steps & Subtasks (${_subtasks.length})',
                        icon: Icons.checklist_rounded,
                        isDark: isDark,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(_subtasks.length, (index) {
                            final checked = _subtaskChecked[index];
                            return CheckboxListTile(
                              dense: true,
                              value: checked,
                              activeColor: const Color(0xFF6366F1),
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(
                                _subtasks[index],
                                style: TextStyle(
                                  fontSize: 13,
                                  decoration: checked ? TextDecoration.lineThrough : null,
                                  color: checked
                                      ? (isDark ? Colors.white38 : Colors.black38)
                                      : (isDark ? Colors.white.withValues(alpha: 0.87) : Colors.black87),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _subtaskChecked[index] = val ?? false;
                                });
                              },
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Section 4: Time Allocation & Priority Reasoning
                    _buildSectionCard(
                      context,
                      title: 'Time Allocation & Priority Reasoning',
                      icon: Icons.hourglass_top_rounded,
                      isDark: isDark,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (timeEstimate != null && timeEstimate.isNotEmpty) ...[
                            Row(
                              children: [
                                const Icon(Icons.timer_rounded, size: 16, color: Colors.cyanAccent),
                                const SizedBox(width: 8),
                                const Text(
                                  'Estimated Duration: ',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                                ),
                                Text(
                                  timeEstimate,
                                  style: const TextStyle(fontSize: 13, color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                          Text(
                            (priorityReason != null && priorityReason.isNotEmpty)
                                ? priorityReason
                                : 'Priority was assigned automatically based on due date proximity and subject workload.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: isDark ? Colors.white70 : Colors.black87,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 5: AI Recommendations & Insights
                    _buildSectionCard(
                      context,
                      title: 'AI Insights & Recommendations',
                      icon: Icons.auto_awesome_rounded,
                      isDark: isDark,
                      accentColor: const Color(0xFF06B6D4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
                                  ),
                                ),
                                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Nexus AI Strategy Note',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Break down this task into 25-minute Pomodoro blocks. Focus on completing key deliverables early to ensure sufficient time for review and submission.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.45,
                              color: isDark ? Colors.white70 : Colors.black87,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isDark,
    required Widget child,
    Color accentColor = const Color(0xFF6366F1),
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: accentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
