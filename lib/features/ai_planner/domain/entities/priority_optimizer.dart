import 'package:equatable/equatable.dart';

/// Domain entity representing a Prioritized Task Item.
class PrioritizedTaskItem extends Equatable {
  final String id;
  final String title;
  final String priorityLevel; // CRITICAL, HIGH, MEDIUM, LOW
  final DateTime deadline;
  final int estimatedMinutes;
  final String priorityExplanation;
  final int recommendedOrder;

  const PrioritizedTaskItem({
    required this.id,
    required this.title,
    required this.priorityLevel,
    required this.deadline,
    required this.estimatedMinutes,
    required this.priorityExplanation,
    required this.recommendedOrder,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        priorityLevel,
        deadline,
        estimatedMinutes,
        priorityExplanation,
        recommendedOrder,
      ];
}

/// Domain entity representing Priority Optimizer result.
class PriorityOptimizer extends Equatable {
  final List<PrioritizedTaskItem> highestPriorityTasks;
  final List<PrioritizedTaskItem> urgentDeadlines;
  final int totalEstimatedTimeMinutes;
  final String overallExplanation;

  const PriorityOptimizer({
    required this.highestPriorityTasks,
    required this.urgentDeadlines,
    required this.totalEstimatedTimeMinutes,
    required this.overallExplanation,
  });

  @override
  List<Object?> get props => [
        highestPriorityTasks,
        urgentDeadlines,
        totalEstimatedTimeMinutes,
        overallExplanation,
      ];
}
