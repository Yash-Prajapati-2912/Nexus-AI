import '../../domain/entities/ai_history_item.dart';

class AIHistoryModel extends AIHistoryItem {
  const AIHistoryModel({
    required super.id,
    required super.prompt,
    required super.responseSummary,
    required super.actionType,
    required super.createdAt,
    super.isBookmarked,
  });

  factory AIHistoryModel.fromJson(Map<String, dynamic> json) {
    return AIHistoryModel(
      id: json['id'] as String? ?? '',
      prompt: json['prompt'] as String? ?? json['actionType'] as String? ?? 'AI Planner Request',
      responseSummary: json['responseSummary'] as String? ?? json['summary'] as String? ?? '',
      actionType: json['actionType'] as String? ?? 'GENERATE_PLAN',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'responseSummary': responseSummary,
      'actionType': actionType,
      'createdAt': createdAt.toIso8601String(),
      'isBookmarked': isBookmarked,
    };
  }

  factory AIHistoryModel.fromEntity(AIHistoryItem entity) {
    return AIHistoryModel(
      id: entity.id,
      prompt: entity.prompt,
      responseSummary: entity.responseSummary,
      actionType: entity.actionType,
      createdAt: entity.createdAt,
      isBookmarked: entity.isBookmarked,
    );
  }
}
