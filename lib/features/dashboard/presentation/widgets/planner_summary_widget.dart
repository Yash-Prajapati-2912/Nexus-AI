import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/design_system/widgets/cards/app_card.dart';
import '../../../planner/domain/entities/task_entity.dart';

class PlannerSummaryWidget extends StatelessWidget {
  final List<TaskEntity> tasks;

  const PlannerSummaryWidget({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    final upcomingTasks = tasks.where((task) {
      if (task.status == TaskStatus.completed) return false;
      final taskDate = DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      return !taskDate.isBefore(todayStart);
    }).toList();

    upcomingTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    final hasTasks = upcomingTasks.isNotEmpty;
    final nearestTask = hasTasks ? upcomingTasks.first : null;
    final secondaryTasks = hasTasks ? upcomingTasks.skip(1).take(2).toList() : <TaskEntity>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Smart Planner Summary',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (hasTasks) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${upcomingTasks.length} remaining',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigoAccent,
                      ),
                    ),
                  ),
                ],
              ],
            ),
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
                    'View Planner',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigoAccent,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 16, color: Colors.indigoAccent),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (!hasTasks)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.event_note_rounded, color: Colors.indigoAccent, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No Upcoming Tasks',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Add tasks to your planner to stay on schedule!',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => context.push(RouteNames.planner),
                  child: const Text('Add Task', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        else
          AppCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrimaryTaskItem(context, nearestTask!, isDark: isDark),
                  if (secondaryTasks.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),
                    const SizedBox(height: 12),
                    ...secondaryTasks.map(
                      (task) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildSecondaryTaskItem(context, task, isDark: isDark),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPrimaryTaskItem(BuildContext context, TaskEntity task, {required bool isDark}) {
    final priorityColor = _getPriorityColor(task.priority);
    final dueString = _formatDueDate(task.dueDate);
    final subject = task.subject;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: priorityColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: priorityColor.withOpacity(0.4),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
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
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    subject,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigoAccent,
                    ),
                  ),
                  Text(
                    ' • ',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.priority.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: priorityColor,
                      ),
                    ),
                  ),
                  Text(
                    ' • ',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                  Text(
                    dueString,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryTaskItem(BuildContext context, TaskEntity task, {required bool isDark}) {
    final priorityColor = _getPriorityColor(task.priority);
    final dueString = _formatDueDate(task.dueDate);

    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: priorityColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            task.title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          dueString,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white38 : Colors.black45,
          ),
        ),
      ],
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
      case TaskPriority.high:
        return const Color(0xFFEF4444);
      case TaskPriority.medium:
        return const Color(0xFFF59E0B);
      case TaskPriority.low:
        return const Color(0xFF3B82F6);
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
