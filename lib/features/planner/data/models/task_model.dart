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

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    this.category,
    this.isRecurring = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      dueDate: json['dueDate'] as String? ?? DateTime.now().toIso8601String(),
      priority: json['priority'] as String? ?? 'medium',
      status: json['status'] as String? ?? 'pending',
      category: json['category'] as String?,
      isRecurring: json['isRecurring'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'dueDate': dueDate,
        'priority': priority,
        'status': status,
        'category': category,
        'isRecurring': isRecurring,
      };

  factory TaskModel.fromDomain(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      dueDate: entity.dueDate.toIso8601String(),
      priority: entity.priority.name,
      status: entity.status.name,
      category: entity.category,
      isRecurring: entity.isRecurring,
    );
  }

  TaskEntity toDomain() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      dueDate: DateTime.tryParse(dueDate) ?? DateTime.now(),
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == priority,
        orElse: () => TaskPriority.medium,
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => TaskStatus.pending,
      ),
      category: category,
      isRecurring: isRecurring,
    );
  }
}
