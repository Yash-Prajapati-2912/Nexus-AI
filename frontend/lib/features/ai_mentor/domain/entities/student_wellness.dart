import 'package:equatable/equatable.dart';

/// Domain entity representing 7-Dimension Student Wellness & Performance Scores.
class StudentWellness extends Equatable {
  final int overallWellnessScore;
  final int academicPerformanceScore;
  final int financialWellnessScore;
  final int productivityScore;
  final int careerReadinessScore;
  final int goalProgressScore;
  final int habitConsistencyScore;
  final String wellnessLevel; // EXCELLENT, BALANCED, NEEDS_ATTENTION, BURNOUT_RISK
  final List<String> keyRecommendations;

  const StudentWellness({
    required this.overallWellnessScore,
    required this.academicPerformanceScore,
    required this.financialWellnessScore,
    required this.productivityScore,
    required this.careerReadinessScore,
    required this.goalProgressScore,
    required this.habitConsistencyScore,
    required this.wellnessLevel,
    required this.keyRecommendations,
  });

  @override
  List<Object?> get props => [
        overallWellnessScore,
        academicPerformanceScore,
        financialWellnessScore,
        productivityScore,
        careerReadinessScore,
        goalProgressScore,
        habitConsistencyScore,
        wellnessLevel,
        keyRecommendations,
      ];
}
