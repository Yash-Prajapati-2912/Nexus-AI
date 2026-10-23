import 'package:equatable/equatable.dart';

/// Domain entity representing Workload Distribution per Day.
class DailyWorkload extends Equatable {
  final String dayName;
  final double studyHours;
  final int totalTasks;
  final bool isBusyDay;

  const DailyWorkload({
    required this.dayName,
    required this.studyHours,
    required this.totalTasks,
    required this.isBusyDay,
  });

  @override
  List<Object?> get props => [dayName, studyHours, totalTasks, isBusyDay];
}

/// Domain entity representing complete Workload Analysis.
class WorkloadAnalysis extends Equatable {
  final double currentWorkloadHours;
  final int busyDaysCount;
  final double freeTimeHours;
  final double studyBalanceScore; // 0 to 100
  final Map<String, int> taskDistribution; // Subject/Type -> Count
  final double assignmentPressureIndex; // 0.0 to 1.0
  final double totalStudyHours;
  final String difficultyLevel; // Low, Balanced, High, Extreme
  final List<DailyWorkload> dailyWorkloads;

  const WorkloadAnalysis({
    required this.currentWorkloadHours,
    required this.busyDaysCount,
    required this.freeTimeHours,
    required this.studyBalanceScore,
    required this.taskDistribution,
    required this.assignmentPressureIndex,
    required this.totalStudyHours,
    required this.difficultyLevel,
    required this.dailyWorkloads,
  });

  @override
  List<Object?> get props => [
        currentWorkloadHours,
        busyDaysCount,
        freeTimeHours,
        studyBalanceScore,
        taskDistribution,
        assignmentPressureIndex,
        totalStudyHours,
        difficultyLevel,
        dailyWorkloads,
      ];
}
