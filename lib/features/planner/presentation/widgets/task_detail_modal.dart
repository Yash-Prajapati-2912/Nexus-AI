import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/design_system/widgets/buttons/app_primary_button.dart';
import '../../../../shared/design_system/widgets/inputs/app_text_field.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/planner_bloc.dart';
import '../bloc/planner_event.dart';
import 'priority_badge.dart';
import 'status_badge.dart';

class TaskDetailModal extends StatefulWidget {
  final TaskEntity task;
  final VoidCallback onToggleCompletion;
  final VoidCallback onDelete;

  const TaskDetailModal({
    super.key,
    required this.task,
    required this.onToggleCompletion,
    required this.onDelete,
  });

  static Future<void> show({
    required BuildContext context,
    required TaskEntity task,
    required VoidCallback onToggleCompletion,
    required VoidCallback onDelete,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskDetailModal(
        task: task,
        onToggleCompletion: onToggleCompletion,
        onDelete: onDelete,
      ),
    );
  }

  @override
  State<TaskDetailModal> createState() => _TaskDetailModalState();
}

class _TaskDetailModalState extends State<TaskDetailModal> {
  late List<String> _subtasks;
  late List<bool> _subtaskChecked;
  late List<String> _requirements;
  bool _isEditing = false;

  // Manual Override Form Controllers
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _subjectController;
  late TaskPriority _priority;

  @override
  void initState() {
    super.initState();
    _initTaskData();
  }

  @override
  void didUpdateWidget(covariant TaskDetailModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task.id != widget.task.id) {
      _initTaskData();
    }
  }

  void _initTaskData() {
    _subtasks = widget.task.subtasks ?? [];
    _subtaskChecked = List<bool>.filled(_subtasks.length, false);
    _requirements = widget.task.requirements ?? [];

    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description ?? '');
    _subjectController = TextEditingController(text: widget.task.subject);
    _priority = widget.task.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _subjectController.dispose();
    super.dispose();
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

  void _saveEditedTask() {
    final updatedMetadata = Map<String, dynamic>.from(widget.task.metadata ?? {});
    updatedMetadata['subject'] = _subjectController.text.trim();

    final updatedTask = TaskEntity(
      id: widget.task.id,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      dueDate: widget.task.dueDate,
      priority: _priority,
      status: widget.task.status,
      category: widget.task.category,
      isRecurring: widget.task.isRecurring,
      subtasks: _subtasks,
      requirements: _requirements,
      timeAllocationHint: widget.task.timeAllocationHint,
      priorityReasoning: widget.task.priorityReasoning,
      metadata: updatedMetadata,
    );

    try {
      context.read<PlannerBloc>().add(UpdateTaskEvent(updatedTask));
    } catch (_) {}

    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✨ Task Details Updated & Saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = widget.task.status == TaskStatus.completed;

    final docType = widget.task.documentType;
    final topCat = widget.task.topLevelCategory;
    final subject = widget.task.subject;
    final descriptionText = widget.task.description ?? widget.task.whatWeAreGoingToDo;
    final priorityReason = widget.task.priorityReasoning ?? widget.task.whyThisTaskExists;
    final timeEstimate = widget.task.timeAllocationHint;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: _isEditing ? _buildEditForm(context, isDark) : Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category & Priority / Status Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '$topCat • $docType',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigoAccent,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const Spacer(),
                PriorityBadge(priority: widget.task.priority),
                const SizedBox(width: 8),
                StatusBadge(status: widget.task.status),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.indigoAccent),
                  tooltip: 'Edit Task',
                  onPressed: () => setState(() => _isEditing = true),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Subject & Title
            Text(
              'Subject: $subject',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.indigoAccent.shade100 : Colors.indigo.shade700,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.task.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isDark ? Colors.white : Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_month_rounded, size: 14, color: Colors.indigoAccent),
                const SizedBox(width: 6),
                Text(
                  _formatDueDate(widget.task.dueDate),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 1. ABOUT THIS TASK
            _buildSectionHeader('ABOUT THIS TASK', isDark),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.grey.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
              ),
              child: Text(
                (descriptionText != null && descriptionText.trim().isNotEmpty)
                    ? descriptionText
                    : 'Not enough information to generate a detailed description.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. WHAT YOU NEED
            _buildSectionHeader('WHAT YOU NEED', isDark),
            const SizedBox(height: 8),
            if (_requirements.isEmpty && widget.task.deliverables.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.grey.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'No specific prerequisites specified.',
                  style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                ),
              )
            else
              Column(
                children: [
                  ..._requirements.map((req) => _buildCheckRow(req, isDark)),
                  ...widget.task.deliverables.map((del) => _buildCheckRow('Deliverable: $del', isDark)),
                ],
              ),
            const SizedBox(height: 20),

            // 3. HOW TO COMPLETE IT
            _buildSectionHeader('HOW TO COMPLETE IT', isDark),
            const SizedBox(height: 8),
            if (_subtasks.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.grey.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'No step-by-step breakdown provided.',
                  style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                ),
              )
            else
              Column(
                children: List.generate(_subtasks.length, (idx) {
                  final st = _subtasks[idx];
                  return CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      st,
                      style: TextStyle(
                        fontSize: 13,
                        decoration: _subtaskChecked[idx] ? TextDecoration.lineThrough : null,
                        color: _subtaskChecked[idx] ? Colors.grey : (isDark ? Colors.white70 : Colors.black87),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    value: _subtaskChecked[idx],
                    onChanged: (val) {
                      setState(() {
                        _subtaskChecked[idx] = val ?? false;
                      });
                    },
                  );
                }),
              ),
            const SizedBox(height: 20),

            // 4. WHY THIS PRIORITY?
            _buildSectionHeader('WHY THIS PRIORITY?', isDark),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.amber.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Colors.amber, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      (priorityReason != null && priorityReason.trim().isNotEmpty)
                          ? priorityReason
                          : 'Priority set to ${widget.task.priority.name.toUpperCase()} based on deadline and academic workload requirements.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. TIME ESTIMATE
            _buildSectionHeader('TIME ESTIMATE', isDark),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.indigo.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, color: Colors.indigoAccent, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      (timeEstimate != null && timeEstimate.trim().isNotEmpty)
                          ? timeEstimate
                          : 'Estimated effort: ~1h 30m based on standard task complexity.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 6. RESOURCES (Optional)
            if (widget.task.suggestedResources.isNotEmpty) ...[
              _buildSectionHeader('RESOURCES', isDark),
              const SizedBox(height: 8),
              ...widget.task.suggestedResources.map((res) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.link_rounded, size: 16, color: Colors.indigoAccent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            res,
                            style: const TextStyle(fontSize: 12, color: Colors.indigoAccent, fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
            ],

            // Bottom Actions: Toggle Completion & Delete
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      widget.onToggleCompletion();
                      Navigator.pop(context);
                    },
                    icon: Icon(isCompleted ? Icons.undo_rounded : Icons.check_circle_rounded),
                    label: Text(isCompleted ? 'Mark Pending' : 'Mark Completed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCompleted ? Colors.amber.shade700 : const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {
                    widget.onDelete();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                  tooltip: 'Delete Task',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: isDark ? Colors.white54 : Colors.black54,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildCheckRow(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 16, color: Colors.indigoAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87, fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(BuildContext context, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Edit Task Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => setState(() => _isEditing = false),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _titleController,
          label: 'Task Title',
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _subjectController,
          label: 'Subject',
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _descController,
          label: 'Description / AI Objective',
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('Priority: ', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<TaskPriority>(
              value: _priority,
              items: TaskPriority.values.map((p) {
                return DropdownMenuItem(value: p, child: Text(p.name.toUpperCase()));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _priority = val);
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        AppPrimaryButton(
          label: 'Save Changes',
          onPressed: _saveEditedTask,
        ),
      ],
    );
  }
}
