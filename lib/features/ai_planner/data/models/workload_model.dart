import '../../domain/entities/workload_analysis.dart';

class DailyWorkloadModel extends DailyWorkload {
  const DailyWorkloadModel({
    required super.dayName,
    required super.studyHours,
    required super.totalTasks,
    required super.isBusyDay,
  });

  factory DailyWorkloadModel.fromJson(Map<String, dynamic> json) {
    return DailyWorkloadModel(
      dayName: json['dayName'] as String? ?? '',
      studyHours: (json['studyHours'] as num?)?.toDouble() ?? 0.0,
      totalTasks: json['totalTasks'] as int? ?? 0,
      isBusyDay: json['isBusyDay'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayName': dayName,
      'studyHours': studyHours,
      'totalTasks': totalTasks,
      'isBusyDay': isBusyDay,
    };
  }
}

class WorkloadModel extends WorkloadAnalysis {
  const WorkloadModel({
    required super.currentWorkloadHours,
    required super.busyDaysCount,
    required super.freeTimeHours,
    required super.studyBalanceScore,
    required super.taskDistribution,
    required super.assignmentPressureIndex,
    required super.totalStudyHours,
    required super.difficultyLevel,
    required super.dailyWorkloads,
  });

  factory WorkloadModel.fromJson(Map<String, dynamic> json) {
    final rawDaily = json['dailyWorkloads'] as List<dynamic>? ?? [];
    final dailyWorkloads = rawDaily
        .map((e) => DailyWorkloadModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final rawDistribution = json['taskDistribution'] as Map<String, dynamic>? ?? {};
    final taskDistribution = rawDistribution.map(
      (key, value) => MapEntry(key, (value as num).toInt()),
    );

    return WorkloadModel(
      currentWorkloadHours: (json['currentWorkloadHours'] as num?)?.toDouble() ?? 0.0,
      busyDaysCount: json['busyDaysCount'] as int? ?? 0,
      freeTimeHours: (json['freeTimeHours'] as num?)?.toDouble() ?? 0.0,
      studyBalanceScore: (json['studyBalanceScore'] as num?)?.toDouble() ?? 75.0,
      taskDistribution: taskDistribution,
      assignmentPressureIndex: (json['assignmentPressureIndex'] as num?)?.toDouble() ?? 0.4,
      totalStudyHours: (json['totalStudyHours'] as num?)?.toDouble() ?? 0.0,
      difficultyLevel: json['difficultyLevel'] as String? ?? 'Balanced',
      dailyWorkloads: dailyWorkloads,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentWorkloadHours': currentWorkloadHours,
      'busyDaysCount': busyDaysCount,
      'freeTimeHours': freeTimeHours,
      'studyBalanceScore': studyBalanceScore,
      'taskDistribution': taskDistribution,
      'assignmentPressureIndex': assignmentPressureIndex,
      'totalStudyHours': totalStudyHours,
      'difficultyLevel': difficultyLevel,
      'dailyWorkloads': dailyWorkloads
          .map((e) => DailyWorkloadModel(
                dayName: e.dayName,
                studyHours: e.studyHours,
                totalTasks: e.totalTasks,
                isBusyDay: e.isBusyDay,
              ).toJson())
          .toList(),
    };
  }

  factory WorkloadModel.fromEntity(WorkloadAnalysis entity) {
    return WorkloadModel(
      currentWorkloadHours: entity.currentWorkloadHours,
      busyDaysCount: entity.busyDaysCount,
      freeTimeHours: entity.freeTimeHours,
      studyBalanceScore: entity.studyBalanceScore,
      taskDistribution: entity.taskDistribution,
      assignmentPressureIndex: entity.assignmentPressureIndex,
      totalStudyHours: entity.totalStudyHours,
      difficultyLevel: entity.difficultyLevel,
      dailyWorkloads: entity.dailyWorkloads,
    );
  }
}
