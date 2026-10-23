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
    Map<String, dynamic> source = json;
    if (json['insights'] is List && (json['insights'] as List).isNotEmpty) {
      final first = (json['insights'] as List).first;
      if (first is Map<String, dynamic>) {
        source = first;
      }
    }
    return AiInsightModel(
      title: source['title'] as String? ?? 'Daily AI Focus',
      insight: source['insight'] as String? ?? source['summary'] as String? ?? source['dailyInsight'] as String? ?? 'Keep up your steady study momentum!',
      motivationalQuote: source['motivationalQuote'] as String? ?? source['detail'] as String? ?? source['productivityTip'] as String? ?? 'Consistency is the key to mastery.',
      recommendedStudyPlan: source['recommendedStudyPlan'] as String? ?? source['todaysRecommendation'] as String? ?? 'Focus 45 mins on core subject modules today.',
      careerSuggestion: source['careerSuggestion'] as String? ?? source['careerTip'] as String? ?? 'Explore building full-stack Flutter projects.',
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
