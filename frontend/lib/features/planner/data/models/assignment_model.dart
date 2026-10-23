import '../../domain/entities/assignment_entity.dart';

class AssignmentModel {
  final String id;
  final String title;
  final String subject;
  final String dueDate;
  final String priority;
  final String status;
  final double progressPercentage;

  const AssignmentModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.progressPercentage,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      dueDate: json['dueDate'] as String? ?? DateTime.now().toIso8601String(),
      priority: json['priority'] as String? ?? 'medium',
      status: json['status'] as String? ?? 'pending',
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subject': subject,
        'dueDate': dueDate,
        'priority': priority,
        'status': status,
        'progressPercentage': progressPercentage,
      };

  factory AssignmentModel.fromDomain(AssignmentEntity entity) {
    return AssignmentModel(
      id: entity.id,
      title: entity.title,
      subject: entity.subject,
      dueDate: entity.dueDate.toIso8601String(),
      priority: entity.priority,
      status: entity.status,
      progressPercentage: entity.progressPercentage,
    );
  }

  AssignmentEntity toDomain() {
    return AssignmentEntity(
      id: id,
      title: title,
      subject: subject,
      dueDate: DateTime.tryParse(dueDate) ?? DateTime.now(),
      priority: priority,
      status: status,
      progressPercentage: progressPercentage,
    );
  }
}
