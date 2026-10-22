import '../../domain/entities/planner_summary_entity.dart';

class PlannerSummaryModel {
  final int todayTasksCount;
  final int completedTasksCount;
  final String? nextAssignmentTitle;
  final String? nextAssignmentDueDate;
  final int priorityTasksCount;
  final double studyProgressPercentage;

  const PlannerSummaryModel({
    required this.todayTasksCount,
    required this.completedTasksCount,
    this.nextAssignmentTitle,
    this.nextAssignmentDueDate,
    required this.priorityTasksCount,
    required this.studyProgressPercentage,
  });

  factory PlannerSummaryModel.fromJson(Map<String, dynamic> json) {
    return PlannerSummaryModel(
      todayTasksCount: (json['todaysTasksCount'] as num? ?? json['todayTasksCount'] as num? ?? json['tasksCompleted'] as num?)?.toInt() ?? 0,
      completedTasksCount: (json['completedTasksCount'] as num? ?? json['tasksCompleted'] as num?)?.toInt() ?? 0,
      nextAssignmentTitle: json['nextAssignmentTitle'] as String?,
      nextAssignmentDueDate: json['nextAssignmentDueDate'] as String?,
      priorityTasksCount: (json['priorityTasksCount'] as num?)?.toInt() ?? 0,
      studyProgressPercentage: ((json['taskCompletionPercentage'] as num? ?? json['studyProgressPercentage'] as num? ?? json['completionRate'] as num?)?.toDouble() ?? 0.0) / 100.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'todayTasksCount': todayTasksCount,
        'completedTasksCount': completedTasksCount,
        'nextAssignmentTitle': nextAssignmentTitle,
        'nextAssignmentDueDate': nextAssignmentDueDate,
        'priorityTasksCount': priorityTasksCount,
        'studyProgressPercentage': studyProgressPercentage,
      };

  PlannerSummaryEntity toDomain() {
    return PlannerSummaryEntity(
      todayTasksCount: todayTasksCount,
      completedTasksCount: completedTasksCount,
      nextAssignmentTitle: nextAssignmentTitle,
      nextAssignmentDueDate: nextAssignmentDueDate != null ? DateTime.tryParse(nextAssignmentDueDate!) : null,
      priorityTasksCount: priorityTasksCount,
      studyProgressPercentage: studyProgressPercentage,
    );
  }
}
