import '../../domain/entities/priority_optimizer.dart';

class PrioritizedTaskItemModel extends PrioritizedTaskItem {
  const PrioritizedTaskItemModel({
    required super.id,
    required super.title,
    required super.priorityLevel,
    required super.deadline,
    required super.estimatedMinutes,
    required super.priorityExplanation,
    required super.recommendedOrder,
  });

  factory PrioritizedTaskItemModel.fromJson(Map<String, dynamic> json) {
    return PrioritizedTaskItemModel(
      id: json['id'] as String? ?? json['taskId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      priorityLevel: json['priorityLevel'] as String? ?? 'MEDIUM',
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : DateTime.now().add(const Duration(days: 1)),
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 60,
      priorityExplanation: json['priorityExplanation'] as String? ?? '',
      recommendedOrder: json['recommendedOrder'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priorityLevel': priorityLevel,
      'deadline': deadline.toIso8601String(),
      'estimatedMinutes': estimatedMinutes,
      'priorityExplanation': priorityExplanation,
      'recommendedOrder': recommendedOrder,
    };
  }
}

class PriorityOptimizerModel extends PriorityOptimizer {
  const PriorityOptimizerModel({
    required super.highestPriorityTasks,
    required super.urgentDeadlines,
    required super.totalEstimatedTimeMinutes,
    required super.overallExplanation,
  });

  factory PriorityOptimizerModel.fromJson(Map<String, dynamic> json) {
    final rawHighest = json['highestPriorityTasks'] as List<dynamic>? ?? [];
    final highestTasks = rawHighest
        .map((e) => PrioritizedTaskItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final rawUrgent = json['urgentDeadlines'] as List<dynamic>? ?? [];
    final urgentTasks = rawUrgent
        .map((e) => PrioritizedTaskItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return PriorityOptimizerModel(
      highestPriorityTasks: highestTasks,
      urgentDeadlines: urgentTasks,
      totalEstimatedTimeMinutes: json['totalEstimatedTimeMinutes'] as int? ?? 180,
      overallExplanation: json['overallExplanation'] as String? ?? json['summary'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'highestPriorityTasks': highestPriorityTasks
          .map((e) => PrioritizedTaskItemModel(
                id: e.id,
                title: e.title,
                priorityLevel: e.priorityLevel,
                deadline: e.deadline,
                estimatedMinutes: e.estimatedMinutes,
                priorityExplanation: e.priorityExplanation,
                recommendedOrder: e.recommendedOrder,
              ).toJson())
          .toList(),
      'urgentDeadlines': urgentDeadlines
          .map((e) => PrioritizedTaskItemModel(
                id: e.id,
                title: e.title,
                priorityLevel: e.priorityLevel,
                deadline: e.deadline,
                estimatedMinutes: e.estimatedMinutes,
                priorityExplanation: e.priorityExplanation,
                recommendedOrder: e.recommendedOrder,
              ).toJson())
          .toList(),
      'totalEstimatedTimeMinutes': totalEstimatedTimeMinutes,
      'overallExplanation': overallExplanation,
    };
  }
}
