import '../../domain/entities/task_entity.dart';

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final String dueDate;
  final String priority;
  final String status;
  final String? category;
  final bool isRecurring;
  final List<String>? subtasks;
  final List<String>? requirements;
  final String? timeAllocationHint;
  final String? priorityReasoning;
  final Map<String, dynamic>? metadata;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    this.category,
    this.isRecurring = false,
    this.subtasks,
    this.requirements,
    this.timeAllocationHint,
    this.priorityReasoning,
    this.metadata,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>?;
    List<String>? parsedSubtasks;
    if (json['subtasks'] is List) {
      parsedSubtasks = (json['subtasks'] as List).map((e) => e.toString()).toList();
    } else if (meta != null && meta['subtasks'] is List) {
      parsedSubtasks = (meta['subtasks'] as List).map((e) => e.toString()).toList();
    }

    List<String>? parsedReqs;
    if (json['requirements'] is List) {
      parsedReqs = (json['requirements'] as List).map((e) => e.toString()).toList();
    } else if (meta != null && meta['requirements'] is List) {
      parsedReqs = (meta['requirements'] as List).map((e) => e.toString()).toList();
    }

    return TaskModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      dueDate: json['dueDate'] as String? ?? DateTime.now().toIso8601String(),
      priority: (json['priority'] as String? ?? 'MEDIUM').toUpperCase(),
      status: (json['status'] as String? ?? 'TODO').toUpperCase(),
      category: json['category'] as String?,
      isRecurring: json['isRecurring'] as bool? ?? false,
      subtasks: parsedSubtasks,
      requirements: parsedReqs,
      timeAllocationHint: json['timeAllocationHint'] as String? ?? meta?['timeAllocationHint'] as String?,
      priorityReasoning: json['priorityReasoning'] as String? ?? meta?['priorityReasoning'] as String?,
      metadata: meta,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'dueDate': dueDate,
        'priority': priority.toUpperCase(),
        'status': status.toUpperCase(),
        'category': category,
        'isRecurring': isRecurring,
        'subtasks': subtasks,
        'requirements': requirements,
        'timeAllocationHint': timeAllocationHint,
        'priorityReasoning': priorityReasoning,
        'metadata': metadata,
      };

  Map<String, dynamic> toCreateJson() {
    final map = <String, dynamic>{
      'title': title,
      'priority': _toBackendPriority(priority),
      'status': _toBackendStatus(status),
      'dueDate': dueDate,
    };
    if (category != null && category!.trim().isNotEmpty) {
      map['category'] = category;
    }
    if (description != null && description!.trim().isNotEmpty) {
      map['description'] = description;
    }
    final metaMap = metadata ?? {};
    if (subtasks != null) metaMap['subtasks'] = subtasks;
    if (requirements != null) metaMap['requirements'] = requirements;
    if (timeAllocationHint != null) metaMap['timeAllocationHint'] = timeAllocationHint;
    if (priorityReasoning != null) metaMap['priorityReasoning'] = priorityReasoning;

    if (metaMap.isNotEmpty) {
      map['metadata'] = metaMap;
    }
    return map;
  }

  static String _toBackendPriority(String p) {
    switch (p.toLowerCase()) {
      case 'high':
        return 'HIGH';
      case 'low':
        return 'LOW';
      case 'urgent':
        return 'URGENT';
      default:
        return 'MEDIUM';
    }
  }

  static String _toBackendStatus(String s) {
    switch (s.toLowerCase()) {
      case 'inprogress':
      case 'in_progress':
        return 'IN_PROGRESS';
      case 'completed':
        return 'COMPLETED';
      case 'archived':
        return 'ARCHIVED';
      case 'pending':
      case 'todo':
      default:
        return 'TODO';
    }
  }

  factory TaskModel.fromDomain(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      dueDate: entity.dueDate.toIso8601String(),
      priority: entity.priority.name.toUpperCase(),
      status: entity.status == TaskStatus.pending ? 'TODO' : entity.status.name.toUpperCase(),
      category: entity.category,
      isRecurring: entity.isRecurring,
      subtasks: entity.subtasks,
      requirements: entity.requirements,
      timeAllocationHint: entity.timeAllocationHint,
      priorityReasoning: entity.priorityReasoning,
      metadata: entity.metadata,
    );
  }

  TaskEntity toDomain() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      dueDate: DateTime.tryParse(dueDate) ?? DateTime.now(),
      priority: TaskPriority.values.firstWhere(
        (e) => e.name.toUpperCase() == priority.toUpperCase(),
        orElse: () => TaskPriority.medium,
      ),
      status: _fromBackendStatus(status),
      category: category,
      isRecurring: isRecurring,
      subtasks: subtasks,
      requirements: requirements,
      timeAllocationHint: timeAllocationHint,
      priorityReasoning: priorityReasoning,
      metadata: metadata,
    );
  }

  static TaskStatus _fromBackendStatus(String s) {
    switch (s.toUpperCase()) {
      case 'IN_PROGRESS':
        return TaskStatus.inProgress;
      case 'COMPLETED':
        return TaskStatus.completed;
      case 'ARCHIVED':
        return TaskStatus.archived;
      case 'TODO':
      case 'PENDING':
      default:
        return TaskStatus.pending;
    }
  }
}
