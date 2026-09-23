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
    _subtasks = _getTaskSubtasks();
    _subtaskChecked = List<bool>.filled(_subtasks.length, false);
    _requirements = _getTaskRequirements();

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

  List<String> _getTaskSubtasks() {
    if (widget.task.subtasks != null && widget.task.subtasks!.isNotEmpty) {
      return widget.task.subtasks!;
    }
    final docType = widget.task.documentType.toUpperCase();
    final title = widget.task.title;

    if (docType == 'SYLLABUS') {
      return [
        '1. Review Unit 1-2 topics and core learning outcomes',
        '2. Review Unit 3-5 topics, teaching scheme, and evaluation criteria',
        '3. Map textbook reading schedule and exam preparation checklist',
      ];
    } else if (docType == 'QUESTION_BANK') {
      return [
        '1. Solve theoretical questions for Units 1–2',
        '2. Solve numerical practice problems for Units 3–5',
        '3. Self-assess solutions against reference study material',
      ];
    } else if (docType == 'NOTES') {
      return [
        '1. Read theoretical lecture material and highlight core definitions',
        '2. Summarize key formulas, block diagrams, and principles',
        '3. Test recall by reviewing unit concept summaries',
      ];
    }

    return [
      '1. Review requirements & gather references for "$title"',
      '2. Complete core problem deliverables for "$title"',
      '3. Proofread, format submission, and verify task guidelines',
    ];
  }

  List<String> _getTaskRequirements() {
    if (widget.task.requirements != null && widget.task.requirements!.isNotEmpty) {
      return widget.task.requirements!;
    }
    final docType = widget.task.documentType.toUpperCase();
    if (docType == 'SYLLABUS') {
      return [
        '📓 Course Syllabus Outline',
        '📚 Recommended Textbooks & Reference List',
        '📅 Semester Exam Schedule',
      ];
    } else if (docType == 'QUESTION_BANK') {
      return [
        '📋 Question Bank Document',
        '📓 Lecture Notes & Study Guides',
        '🖊️ Practice Worksheet',
      ];
    }
    return [
      '📓 Course Notes & Task Guidelines',
      '💻 Laptop / Workspace Environment',
      '📋 Submission Checklist',
    ];
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
      const SnackBar(content: Text('✨ Task Details Updated & Saved Successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = widget.task.status == TaskStatus.completed;

    final docType = widget.task.documentType;
    final topCat = widget.task.topLevelCategory;
    final subject = widget.task.subject;
    final subCat = widget.task.subCategory;
    final whatWeAreGoingToDo = widget.task.whatWeAreGoingToDo ?? widget.task.description ?? 'Complete task deliverables.';
    final whyThisTaskExists = widget.task.whyThisTaskExists ?? widget.task.priorityReasoning ?? 'Academic course evaluation.';
    final deliverables = widget.task.deliverables;
    final sourceFileName = widget.task.sourceFileName;

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
            // Handle bar
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

            // Top Row: Category Tag & Badges & Edit Button
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
                    '$subCat • $docType',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigoAccent,
                    ),
                  ),
                ),
                const Spacer(),
                PriorityBadge(priority: widget.task.priority),
                const SizedBox(width: 8),
                StatusBadge(status: widget.task.status),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.indigoAccent),
                  tooltip: 'Manual Edit / Override',
                  onPressed: () => setState(() => _isEditing = true),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Subject Pill
            Text(
              'Subject: $subject | Category: $topCat',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Task Title
            Text(
              widget.task.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // AI Priority & Executive Study Plan Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.indigo.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.amber, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'AI Academic Insights',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.task.timeAllocationHint ?? '⏱️ Workload: Standard Coursework Task',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    whyThisTaskExists,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // WHAT WE ARE GOING TO DO
            Text(
              'What We Are Going To Do',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            // DOCUMENT FACTS vs AI RECOMMENDATIONS
            Text(
              'Document Facts (Official Requirements)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Objective: $whatWeAreGoingToDo', style: const TextStyle(fontSize: 13, height: 1.3)),
                  const SizedBox(height: 6),
                  Text(
                    'Deadline: ${widget.task.dueDate.toIso8601String().substring(0, 10)}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigoAccent),
                  ),
                  if (widget.task.taskEvidence.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text('Direct Evidence Quote: "${widget.task.taskEvidence.first}"', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (widget.task.aiRecommendations.isNotEmpty) ...[
              Text(
                'AI Recommendations & Study Strategy',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              ...widget.task.aiRecommendations.map((rec) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, size: 14, color: Colors.amber),
                    const SizedBox(width: 6),
                    Expanded(child: Text(rec, style: const TextStyle(fontSize: 12))),
                  ],
                ),
              )),
              const SizedBox(height: 20),
            ],

            // WHAT WILL BE REQUIRED (Prerequisites)
            Text(
              'Prerequisites / What Will Be Required',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.blueGrey.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: _requirements.map((req) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, size: 16, color: Colors.indigoAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          req,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // DELIVERABLES (If present)
            if (deliverables.isNotEmpty) ...[
              Text(
                'Deliverables',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              ...deliverables.map((deliv) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.folder_zip_outlined, size: 16, color: Colors.amber),
                    const SizedBox(width: 6),
                    Text(deliv, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
              const SizedBox(height: 20),
            ],

            // SOURCE FILE NAME (If present)
            if (sourceFileName != null && sourceFileName.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.attach_file, size: 16, color: Colors.indigoAccent),
                  const SizedBox(width: 6),
                  Text(
                    'Source Document: $sourceFileName',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigoAccent),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // ACTION STEPS & MILESTONES
            Text(
              'Action Steps & Milestones',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(
              _subtasks.length,
              (index) => _buildSubtaskTile(_subtasks[index], index),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: AppPrimaryButton(
                    label: isCompleted ? 'Mark Incomplete' : '✓ Complete Task',
                    onPressed: () {
                      widget.onToggleCompletion();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 28),
                  tooltip: 'Delete Task',
                  onPressed: () {
                    widget.onDelete();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm(BuildContext context, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text(
              'Manual Override & Edit Task',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close),
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
          label: 'Subject (e.g. ICD, MCWN, Employability)',
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _descController,
          label: 'Task Description / Action Details',
          maxLines: 3,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<TaskPriority>(
          value: _priority,
          decoration: const InputDecoration(labelText: 'Priority'),
          items: TaskPriority.values
              .map((p) => DropdownMenuItem(value: p, child: Text(p.name.toUpperCase())))
              .toList(),
          onChanged: (val) {
            if (val != null) setState(() => _priority = val);
          },
        ),
        const SizedBox(height: 20),
        AppPrimaryButton(
          label: 'Save Changes',
          onPressed: _saveEditedTask,
        ),
      ],
    );
  }

  Widget _buildSubtaskTile(String label, int index) {
    return CheckboxListTile(
      value: _subtaskChecked[index],
      dense: true,
      contentPadding: EdgeInsets.zero,
      activeColor: Colors.indigoAccent,
      title: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          decoration: _subtaskChecked[index] ? TextDecoration.lineThrough : null,
        ),
      ),
      onChanged: (val) {
        setState(() {
          _subtaskChecked[index] = val ?? false;
        });
      },
    );
  }
}
