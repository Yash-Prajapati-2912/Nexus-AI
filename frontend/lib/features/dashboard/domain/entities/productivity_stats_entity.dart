import 'package:equatable/equatable.dart';

class ProductivityStatsEntity extends Equatable {
  final int dailyScore;
  final int streakDays;
  final double studyHoursThisWeek;
  final int completedTasksThisWeek;

  const ProductivityStatsEntity({
    required this.dailyScore,
    required this.streakDays,
    required this.studyHoursThisWeek,
    required this.completedTasksThisWeek,
  });

  @override
  List<Object?> get props => [
        dailyScore,
        streakDays,
        studyHoursThisWeek,
        completedTasksThisWeek,
      ];
}
