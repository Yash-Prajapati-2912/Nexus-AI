import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/ai_mentor/data/models/student_wellness_model.dart';

void main() {
  group('StudentWellnessModel', () {
    test('correctly parses backend field names', () {
      final backendJson = {
        'overallStudentWellnessScore': 78.4,
        'studyReadinessScore': 85.0,
        'financialStabilityScore': 60.5,
        'productivityScore': 90.0,
        'careerReadinessScore': 75.0,
        'goalProgressScore': 80.0,
        'consistencyScore': 88.0,
      };

      final model = StudentWellnessModel.fromJson(backendJson);

      expect(model.overallWellnessScore, 78);
      expect(model.academicPerformanceScore, 85);
      expect(model.financialWellnessScore, 61);
      expect(model.productivityScore, 90);
      expect(model.careerReadinessScore, 75);
      expect(model.goalProgressScore, 80);
      expect(model.habitConsistencyScore, 88);
      expect(model.wellnessLevel, 'BALANCED');
    });

    test('correctly parses frontend alias field names and numeric strings', () {
      final aliasJson = {
        'overallWellnessScore': '92',
        'academicPerformanceScore': '88',
        'financialWellnessScore': '84',
        'productivityScore': '95',
        'careerReadinessScore': '80',
        'goalProgressScore': '87',
        'habitConsistencyScore': '91',
        'wellnessLevel': 'EXCELLENT',
        'keyRecommendations': ['Great momentum!'],
      };

      final model = StudentWellnessModel.fromJson(aliasJson);

      expect(model.overallWellnessScore, 92);
      expect(model.academicPerformanceScore, 88);
      expect(model.financialWellnessScore, 84);
      expect(model.productivityScore, 95);
      expect(model.wellnessLevel, 'EXCELLENT');
      expect(model.keyRecommendations, ['Great momentum!']);
    });

    test('throws FormatException on malformed/empty payload', () {
      final emptyJson = <String, dynamic>{};

      expect(() => StudentWellnessModel.fromJson(emptyJson), throwsFormatException);
    });

    test('toJson produces both backend keys and frontend aliases', () {
      const model = StudentWellnessModel(
        overallWellnessScore: 80,
        academicPerformanceScore: 75,
        financialWellnessScore: 85,
        productivityScore: 90,
        careerReadinessScore: 70,
        goalProgressScore: 78,
        habitConsistencyScore: 82,
        wellnessLevel: 'BALANCED',
        keyRecommendations: ['Test rec'],
      );

      final json = model.toJson();

      expect(json['overallStudentWellnessScore'], 80);
      expect(json['overallWellnessScore'], 80);
      expect(json['studyReadinessScore'], 75);
      expect(json['academicPerformanceScore'], 75);
      expect(json['financialStabilityScore'], 85);
      expect(json['financialWellnessScore'], 85);
      expect(json['consistencyScore'], 82);
      expect(json['habitConsistencyScore'], 82);
    });
  });
}
