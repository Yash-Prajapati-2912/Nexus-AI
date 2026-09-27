import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../../../planner/domain/entities/task_entity.dart';

class PlannerSummaryWidget extends StatelessWidget {
  final List<TaskEntity> tasks;

  const PlannerSummaryWidget({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // A task is upcoming/active if it is not completed
    final activeTasks = tasks.where((t) => t.status != TaskStatus.completed).toList();
    activeTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    final hasTasks = activeTasks.isNotEmpty;
    final displayTasks = activeTasks.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.task_alt_rounded,
                    size: 20,
                    color: DesignColors.primaryDark,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "What's Next • Smart Planner",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (hasTasks) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: DesignColors.primaryDark.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${activeTasks.length} active',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: DesignColors.primaryDark,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => context.push(RouteNames.planner),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: DesignColors.primaryDark,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 16, color: DesignColors.primaryDark),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (!hasTasks)
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 360;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: DesignColors.primaryDark.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.event_available_rounded, color: DesignColors.primaryDark, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No Upcoming Tasks',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'You are all caught up! Add tasks in Planner to stay on schedule.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isNarrow) ...[
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: DesignColors.primaryDark,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () => context.push(RouteNames.planner),
                            child: const Text(
                              'Add Task',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (isNarrow) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DesignColors.primaryDark,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => context.push(RouteNames.planner),
                          child: const Text(
                            'Add Task',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          )
        else
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayTasks.length,
              separatorBuilder: (context, index) => Divider(
                height: 16,
                thickness: 1,
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
              ),
              itemBuilder: (context, index) {
                final task = displayTasks[index];
                return _buildTaskTile(context, task, isDark: isDark);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildTaskTile(BuildContext context, TaskEntity task, {required bool isDark}) {
    final priorityColor = _getPriorityColor(task.priority);
    final dueString = _formatDueDate(task.dueDate);
    final subject = task.subject.isNotEmpty ? task.subject : 'Academic';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: priorityColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: priorityColor.withValues(alpha: 0.4),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                  fontFamily: 'Poppins',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: DesignColors.secondaryDark,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    ' • ',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.priority.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: priorityColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            dueString,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: dueString.contains('overdue')
                  ? DesignColors.errorDark
                  : isDark
                      ? DesignColors.textSecondaryDark
                      : DesignColors.textSecondaryLight,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
      case TaskPriority.high:
        return DesignColors.errorDark;
      case TaskPriority.medium:
        return const Color(0xFFF59E0B);
      case TaskPriority.low:
        return DesignColors.secondaryDark;
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final diffDays = target.difference(today).inDays;

    if (diffDays == 0) {
      return 'Due Today';
    } else if (diffDays == 1) {
      return 'Due Tomorrow';
    } else if (diffDays < 0) {
      return '${diffDays.abs()}d overdue';
    } else if (diffDays <= 7) {
      return 'Due in $diffDays days';
    } else {
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return 'Due ${months[dueDate.month - 1]} ${dueDate.day}';
    }
  }
}
