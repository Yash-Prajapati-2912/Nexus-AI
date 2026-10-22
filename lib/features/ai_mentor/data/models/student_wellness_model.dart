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

  static int? _tryParseScore(Map<String, dynamic> json, List<String> candidateKeys) {
    for (final key in candidateKeys) {
      final val = json[key];
      if (val is num) {
        return val.round();
      }
      if (val is String) {
        final parsed = num.tryParse(val);
        if (parsed != null) {
          return parsed.round();
        }
      }
    }
    return null;
  }

  factory StudentWellnessModel.fromJson(Map<String, dynamic> rawJson) {
    final Map<String, dynamic> json = (rawJson['data'] is Map<String, dynamic>)
        ? rawJson['data'] as Map<String, dynamic>
        : rawJson;

    // Parse scores using actual backend field names with frontend aliases for backward compatibility
    final overall = _tryParseScore(json, [
      'overallStudentWellnessScore',
      'overallWellnessScore',
      'wellnessScore',
      'overallScore',
    ]);
    final academic = _tryParseScore(json, [
      'studyReadinessScore',
      'academicPerformanceScore',
      'academicScore',
      'studyScore',
    ]);
    final financial = _tryParseScore(json, [
      'financialStabilityScore',
      'financialWellnessScore',
      'financeScore',
      'financialScore',
    ]);
    final productivity = _tryParseScore(json, [
      'productivityScore',
    ]);
    final career = _tryParseScore(json, [
      'careerReadinessScore',
      'careerScore',
    ]);
    final goal = _tryParseScore(json, [
      'goalProgressScore',
      'goalScore',
    ]);
    final consistency = _tryParseScore(json, [
      'consistencyScore',
      'habitConsistencyScore',
      'habitScore',
    ]);

    // If no score metrics could be parsed, reject malformed response instead of substituting hardcoded scores
    if (overall == null && academic == null && financial == null && productivity == null) {
      throw const FormatException('Malformed wellness score response: no valid score metrics found');
    }

    // Resolve derived or fallback values safely from present metrics
    final resolvedOverall = overall ??
        (((academic ?? 0) + (financial ?? 0) + (productivity ?? 0)) > 0
            ? (((academic ?? 0) + (financial ?? 0) + (productivity ?? 0)) ~/ 3)
            : 75);
    final resolvedAcademic = academic ?? resolvedOverall;
    final resolvedFinancial = financial ?? resolvedOverall;
    final resolvedProductivity = productivity ?? resolvedOverall;
    final resolvedCareer = career ?? resolvedOverall;
    final resolvedGoal = goal ?? resolvedOverall;
    final resolvedConsistency = consistency ?? resolvedOverall;

    // Determine wellness level from explicit field or calculate from overall score
    String resolvedWellnessLevel = json['wellnessLevel'] as String? ?? '';
    if (resolvedWellnessLevel.isEmpty) {
      if (resolvedOverall >= 85) {
        resolvedWellnessLevel = 'EXCELLENT';
      } else if (resolvedOverall >= 70) {
        resolvedWellnessLevel = 'BALANCED';
      } else if (resolvedOverall >= 50) {
        resolvedWellnessLevel = 'NEEDS_ATTENTION';
      } else {
        resolvedWellnessLevel = 'BURNOUT_RISK';
      }
    }

    final rawRecs = json['keyRecommendations'] as List<dynamic>? ?? [];
    final recs = rawRecs.map((e) => e.toString()).toList();

    return StudentWellnessModel(
      overallWellnessScore: resolvedOverall,
      academicPerformanceScore: resolvedAcademic,
      financialWellnessScore: resolvedFinancial,
      productivityScore: resolvedProductivity,
      careerReadinessScore: resolvedCareer,
      goalProgressScore: resolvedGoal,
      habitConsistencyScore: resolvedConsistency,
      wellnessLevel: resolvedWellnessLevel,
      keyRecommendations: recs.isNotEmpty
          ? recs
          : const [
              'Maintain study schedule consistency',
              'Schedule regular focus and rest breaks',
            ],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overallStudentWellnessScore': overallWellnessScore,
      'overallWellnessScore': overallWellnessScore,
      'studyReadinessScore': academicPerformanceScore,
      'academicPerformanceScore': academicPerformanceScore,
      'financialStabilityScore': financialWellnessScore,
      'financialWellnessScore': financialWellnessScore,
      'productivityScore': productivityScore,
      'careerReadinessScore': careerReadinessScore,
      'goalProgressScore': goalProgressScore,
      'consistencyScore': habitConsistencyScore,
      'habitConsistencyScore': habitConsistencyScore,
      'wellnessLevel': wellnessLevel,
      'keyRecommendations': keyRecommendations,
    };
  }
}
