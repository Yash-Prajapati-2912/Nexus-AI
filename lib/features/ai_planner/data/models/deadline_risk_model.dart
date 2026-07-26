import '../../domain/entities/deadline_risk.dart';

class CriticalDeadlineItemModel extends CriticalDeadlineItem {
  const CriticalDeadlineItemModel({
    required super.taskId,
    required super.title,
    required super.dueDate,
    required super.lateProbability,
    required super.riskLevel,
    required super.warningMessage,
  });

  factory CriticalDeadlineItemModel.fromJson(Map<String, dynamic> json) {
    return CriticalDeadlineItemModel(
      taskId: json['taskId'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : DateTime.now().add(const Duration(days: 2)),
      lateProbability: (json['lateProbability'] as num?)?.toDouble() ?? 0.5,
      riskLevel: json['riskLevel'] as String? ?? 'HIGH',
      warningMessage: json['warningMessage'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'lateProbability': lateProbability,
      'riskLevel': riskLevel,
      'warningMessage': warningMessage,
    };
  }
}

class DeadlineRiskModel extends DeadlineRisk {
  const DeadlineRiskModel({
    required super.overallLateRiskPercentage,
    required super.criticalDeadlines,
    required super.upcomingDeadlines,
    required super.warningCards,
  });

  factory DeadlineRiskModel.fromJson(Map<String, dynamic> json) {
    final rawCritical = json['criticalDeadlines'] as List<dynamic>? ?? [];
    final critical = rawCritical
        .map((e) => CriticalDeadlineItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final rawUpcoming = json['upcomingDeadlines'] as List<dynamic>? ?? [];
    final upcoming = rawUpcoming
        .map((e) => CriticalDeadlineItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final rawWarnings = json['warningCards'] as List<dynamic>? ?? json['warnings'] as List<dynamic>? ?? [];
    final warningCards = rawWarnings.map((e) => e.toString()).toList();

    return DeadlineRiskModel(
      overallLateRiskPercentage: (json['overallLateRiskPercentage'] as num?)?.toDouble() ?? 25.0,
      criticalDeadlines: critical,
      upcomingDeadlines: upcoming,
      warningCards: warningCards,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overallLateRiskPercentage': overallLateRiskPercentage,
      'criticalDeadlines': criticalDeadlines
          .map((e) => CriticalDeadlineItemModel(
                taskId: e.taskId,
                title: e.title,
                dueDate: e.dueDate,
                lateProbability: e.lateProbability,
                riskLevel: e.riskLevel,
                warningMessage: e.warningMessage,
              ).toJson())
          .toList(),
      'upcomingDeadlines': upcomingDeadlines
          .map((e) => CriticalDeadlineItemModel(
                taskId: e.taskId,
                title: e.title,
                dueDate: e.dueDate,
                lateProbability: e.lateProbability,
                riskLevel: e.riskLevel,
                warningMessage: e.warningMessage,
              ).toJson())
          .toList(),
      'warningCards': warningCards,
    };
  }
}
