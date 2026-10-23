import '../../domain/entities/productivity_stats_entity.dart';

class ProductivityStatsModel {
  final int dailyScore;
  final int streakDays;
  final double studyHoursThisWeek;
  final int completedTasksThisWeek;

  const ProductivityStatsModel({
    required this.dailyScore,
    required this.streakDays,
    required this.studyHoursThisWeek,
    required this.completedTasksThisWeek,
  });

  factory ProductivityStatsModel.fromJson(Map<String, dynamic> json) {
    return ProductivityStatsModel(
      dailyScore: (json['dailyScore'] as num?)?.toInt() ?? 0,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      studyHoursThisWeek: (json['studyHoursThisWeek'] as num?)?.toDouble() ?? 0.0,
      completedTasksThisWeek: (json['completedTasksThisWeek'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'dailyScore': dailyScore,
        'streakDays': streakDays,
        'studyHoursThisWeek': studyHoursThisWeek,
        'completedTasksThisWeek': completedTasksThisWeek,
      };

  ProductivityStatsEntity toDomain() {
    return ProductivityStatsEntity(
      dailyScore: dailyScore,
      streakDays: streakDays,
      studyHoursThisWeek: studyHoursThisWeek,
      completedTasksThisWeek: completedTasksThisWeek,
    );
  }
}
