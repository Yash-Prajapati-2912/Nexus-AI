import 'package:equatable/equatable.dart';

/// Domain entity representing Statistics Dashboard & Analytics.
class UserStatistics extends Equatable {
  final int studyStreakDays;
  final double totalStudyHours;
  final int productivityScore;
  final int plannerTasksCompleted;
  final double financeSavingsTotal;
  final int aiQueriesCount;
  final int goalsCompletedCount;
  final List<double> weeklyProgress;
  final List<double> monthlyProgress;

  const UserStatistics({
    required this.studyStreakDays,
    required this.totalStudyHours,
    required this.productivityScore,
    required this.plannerTasksCompleted,
    required this.financeSavingsTotal,
    required this.aiQueriesCount,
    required this.goalsCompletedCount,
    required this.weeklyProgress,
    required this.monthlyProgress,
  });

  @override
  List<Object?> get props => [
        studyStreakDays,
        totalStudyHours,
        productivityScore,
        plannerTasksCompleted,
        financeSavingsTotal,
        aiQueriesCount,
        goalsCompletedCount,
        weeklyProgress,
        monthlyProgress,
      ];
}
