import 'package:equatable/equatable.dart';

class AiInsightEntity extends Equatable {
  final String title;
  final String insight;
  final String motivationalQuote;
  final String recommendedStudyPlan;
  final String careerSuggestion;

  const AiInsightEntity({
    required this.title,
    required this.insight,
    required this.motivationalQuote,
    required this.recommendedStudyPlan,
    required this.careerSuggestion,
  });

  @override
  List<Object?> get props => [
        title,
        insight,
        motivationalQuote,
        recommendedStudyPlan,
        careerSuggestion,
      ];
}
