import 'package:equatable/equatable.dart';

class AssignmentEntity extends Equatable {
  final String id;
  final String title;
  final String subject;
  final DateTime dueDate;
  final String priority;
  final String status;
  final double progressPercentage;

  const AssignmentEntity({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.progressPercentage,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subject,
        dueDate,
        priority,
        status,
        progressPercentage,
      ];
}
