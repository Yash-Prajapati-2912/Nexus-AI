import '../../domain/entities/user_statistics.dart';

class UserStatisticsModel extends UserStatistics {
  const UserStatisticsModel({
    required super.studyStreakDays,
    required super.totalStudyHours,
    required super.productivityScore,
    required super.plannerTasksCompleted,
    required super.financeSavingsTotal,
    required super.aiQueriesCount,
    required super.goalsCompletedCount,
    required super.weeklyProgress,
    required super.monthlyProgress,
  });

  factory UserStatisticsModel.fromJson(Map<String, dynamic> json) {
    final rawW = json['weeklyProgress'] as List<dynamic>? ?? [4.5, 6.0, 5.2, 7.1, 8.0, 6.5, 9.2];
    final rawM = json['monthlyProgress'] as List<dynamic>? ?? [120, 145, 160, 180];

    return UserStatisticsModel(
      studyStreakDays: json['studyStreakDays'] as int? ?? (json['streak'] as int? ?? 14),
      totalStudyHours: (json['totalStudyHours'] as num?)?.toDouble() ?? 128.5,
      productivityScore: json['productivityScore'] as int? ?? 88,
      plannerTasksCompleted: json['plannerTasksCompleted'] as int? ?? 64,
      financeSavingsTotal: (json['financeSavingsTotal'] as num?)?.toDouble() ?? 1450.75,
      aiQueriesCount: json['aiQueriesCount'] as int? ?? 142,
      goalsCompletedCount: json['goalsCompletedCount'] as int? ?? 8,
      weeklyProgress: rawW.map((e) => (e as num).toDouble()).toList(),
      monthlyProgress: rawM.map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studyStreakDays': studyStreakDays,
      'totalStudyHours': totalStudyHours,
      'productivityScore': productivityScore,
      'plannerTasksCompleted': plannerTasksCompleted,
      'financeSavingsTotal': financeSavingsTotal,
      'aiQueriesCount': aiQueriesCount,
      'goalsCompletedCount': goalsCompletedCount,
      'weeklyProgress': weeklyProgress,
      'monthlyProgress': monthlyProgress,
    };
  }
}
