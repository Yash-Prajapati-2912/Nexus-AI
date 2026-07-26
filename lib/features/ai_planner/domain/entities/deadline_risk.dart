import 'package:equatable/equatable.dart';

/// Domain entity representing a Specific Critical Deadline.
class CriticalDeadlineItem extends Equatable {
  final String taskId;
  final String title;
  final DateTime dueDate;
  final double lateProbability; // 0.0 to 1.0
  final String riskLevel; // CRITICAL, HIGH, MODERATE, LOW
  final String warningMessage;

  const CriticalDeadlineItem({
    required this.taskId,
    required this.title,
    required this.dueDate,
    required this.lateProbability,
    required this.riskLevel,
    required this.warningMessage,
  });

  @override
  List<Object?> get props => [
        taskId,
        title,
        dueDate,
        lateProbability,
        riskLevel,
        warningMessage,
      ];
}

/// Domain entity for Deadline Risk Analysis.
class DeadlineRisk extends Equatable {
  final double overallLateRiskPercentage;
  final List<CriticalDeadlineItem> criticalDeadlines;
  final List<CriticalDeadlineItem> upcomingDeadlines;
  final List<String> warningCards;

  const DeadlineRisk({
    required this.overallLateRiskPercentage,
    required this.criticalDeadlines,
    required this.upcomingDeadlines,
    required this.warningCards,
  });

  @override
  List<Object?> get props => [
        overallLateRiskPercentage,
        criticalDeadlines,
        upcomingDeadlines,
        warningCards,
      ];
}
