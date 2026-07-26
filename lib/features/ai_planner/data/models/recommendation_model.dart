import '../../domain/entities/recommendation.dart';

class RecommendationModel extends Recommendation {
  const RecommendationModel({
    required super.id,
    required super.title,
    required super.description,
    required super.priority,
    required super.category,
    super.actionUrl,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      id: json['id'] as String? ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      priority: json['priority'] as String? ?? 'HIGH',
      category: json['category'] as String? ?? json['type'] as String? ?? 'STUDY_TIME',
      actionUrl: json['linkUrl'] as String? ?? json['actionUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'category': category,
      'actionUrl': actionUrl,
    };
  }

  factory RecommendationModel.fromEntity(Recommendation entity) {
    return RecommendationModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      priority: entity.priority,
      category: entity.category,
      actionUrl: entity.actionUrl,
    );
  }
}
