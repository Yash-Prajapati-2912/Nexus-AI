import '../../domain/entities/student_wellness.dart';

class StudentWellnessModel extends StudentWellness {
  const StudentWellnessModel({
    required super.overallWellnessScore,
    required super.academicPerformanceScore,
    required super.financialWellnessScore,
    required super.productivityScore,
    required super.careerReadinessScore,
    required super.goalProgressScore,
    required super.habitConsistencyScore,
    required super.wellnessLevel,
    required super.keyRecommendations,
  });

  factory StudentWellnessModel.fromJson(Map<String, dynamic> json) {
    final rawRecs = json['keyRecommendations'] as List<dynamic>? ?? [];
    final recs = rawRecs.map((e) => e.toString()).toList();

    return StudentWellnessModel(
      overallWellnessScore: json['overallWellnessScore'] as int? ?? json['wellnessScore'] as int? ?? 86,
      academicPerformanceScore: json['academicPerformanceScore'] as int? ?? 82,
      financialWellnessScore: json['financialWellnessScore'] as int? ?? 84,
      productivityScore: json['productivityScore'] as int? ?? 88,
      careerReadinessScore: json['careerReadinessScore'] as int? ?? 78,
      goalProgressScore: json['goalProgressScore'] as int? ?? 85,
      habitConsistencyScore: json['habitConsistencyScore'] as int? ?? 89,
      wellnessLevel: json['wellnessLevel'] as String? ?? 'BALANCED',
      keyRecommendations: recs.isNotEmpty
          ? recs
          : ['Maintain study schedule consistency', 'Schedule 1 hour outdoor break daily'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overallWellnessScore': overallWellnessScore,
      'academicPerformanceScore': academicPerformanceScore,
      'financialWellnessScore': financialWellnessScore,
      'productivityScore': productivityScore,
      'careerReadinessScore': careerReadinessScore,
      'goalProgressScore': goalProgressScore,
      'habitConsistencyScore': habitConsistencyScore,
      'wellnessLevel': wellnessLevel,
      'keyRecommendations': keyRecommendations,
    };
  }
}
