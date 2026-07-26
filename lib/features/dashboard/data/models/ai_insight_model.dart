import '../../domain/entities/ai_insight_entity.dart';

class AiInsightModel {
  final String title;
  final String insight;
  final String motivationalQuote;
  final String recommendedStudyPlan;
  final String careerSuggestion;

  const AiInsightModel({
    required this.title,
    required this.insight,
    required this.motivationalQuote,
    required this.recommendedStudyPlan,
    required this.careerSuggestion,
  });

  factory AiInsightModel.fromJson(Map<String, dynamic> json) {
    return AiInsightModel(
      title: json['title'] as String? ?? 'Daily AI Focus',
      insight: json['insight'] as String? ?? 'Keep up your steady study momentum!',
      motivationalQuote: json['motivationalQuote'] as String? ?? 'Consistency is the key to mastery.',
      recommendedStudyPlan: json['recommendedStudyPlan'] as String? ?? 'Focus 45 mins on core subject modules today.',
      careerSuggestion: json['careerSuggestion'] as String? ?? 'Explore building full-stack Flutter projects.',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'insight': insight,
        'motivationalQuote': motivationalQuote,
        'recommendedStudyPlan': recommendedStudyPlan,
        'careerSuggestion': careerSuggestion,
      };

  AiInsightEntity toDomain() {
    return AiInsightEntity(
      title: title,
      insight: insight,
      motivationalQuote: motivationalQuote,
      recommendedStudyPlan: recommendedStudyPlan,
      careerSuggestion: careerSuggestion,
    );
  }
}
