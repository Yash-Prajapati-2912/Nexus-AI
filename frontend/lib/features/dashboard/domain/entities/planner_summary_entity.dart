import 'package:equatable/equatable.dart';

class PlannerSummaryEntity extends Equatable {
  final int todayTasksCount;
  final int completedTasksCount;
  final String? nextAssignmentTitle;
  final DateTime? nextAssignmentDueDate;
  final int priorityTasksCount;
  final double studyProgressPercentage;

  const PlannerSummaryEntity({
    required this.todayTasksCount,
    required this.completedTasksCount,
    this.nextAssignmentTitle,
    this.nextAssignmentDueDate,
    required this.priorityTasksCount,
    required this.studyProgressPercentage,
  });

  @override
  List<Object?> get props => [
        todayTasksCount,
        completedTasksCount,
        nextAssignmentTitle,
        nextAssignmentDueDate,
        priorityTasksCount,
        studyProgressPercentage,
      ];
}
