import '../../domain/entities/study_plan.dart';

class ActionItemModel extends ActionItem {
  const ActionItemModel({
    required super.step,
    required super.title,
    required super.allocatedMinutes,
    required super.targetDate,
    required super.category,
  });

  factory ActionItemModel.fromJson(Map<String, dynamic> json) {
    return ActionItemModel(
      step: json['step'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      allocatedMinutes: json['allocatedMinutes'] as int? ?? 60,
      targetDate: json['targetDate'] != null
          ? DateTime.parse(json['targetDate'] as String)
          : DateTime.now(),
      category: json['category'] as String? ?? 'General',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step': step,
      'title': title,
      'allocatedMinutes': allocatedMinutes,
      'targetDate': targetDate.toIso8601String(),
      'category': category,
    };
  }

  factory ActionItemModel.fromEntity(ActionItem entity) {
    return ActionItemModel(
      step: entity.step,
      title: entity.title,
      allocatedMinutes: entity.allocatedMinutes,
      targetDate: entity.targetDate,
      category: entity.category,
    );
  }
}

class StudyPlanModel extends StudyPlan {
  const StudyPlanModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.timeframe,
    required super.reasoning,
    required super.actionItems,
    required super.warnings,
    required super.confidenceScore,
    required super.providerName,
    required super.createdAt,
    super.isSaved,
  });

  factory StudyPlanModel.fromJson(Map<String, dynamic> json) {
    final rawActions = json['actionItems'] as List<dynamic>? ?? [];
    final actionItems = rawActions
        .map((e) => ActionItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final rawReasoning = json['reasoning'] as List<dynamic>? ?? [];
    final reasoning = rawReasoning.map((e) => e.toString()).toList();

    final rawWarnings = json['warnings'] as List<dynamic>? ?? [];
    final warnings = rawWarnings.map((e) => e.toString()).toList();

    return StudyPlanModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'AI Generated Study Plan',
      summary: json['summary'] as String? ?? '',
      timeframe: json['timeframe'] as String? ?? 'weekly',
      reasoning: reasoning,
      actionItems: actionItems,
      warnings: warnings,
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble() ?? 0.9,
      providerName: json['providerName'] as String? ?? 'GEMINI',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'timeframe': timeframe,
      'reasoning': reasoning,
      'actionItems': actionItems
          .map((e) => ActionItemModel.fromEntity(e).toJson())
          .toList(),
      'warnings': warnings,
      'confidenceScore': confidenceScore,
      'providerName': providerName,
      'createdAt': createdAt.toIso8601String(),
      'isSaved': isSaved,
    };
  }

  factory StudyPlanModel.fromEntity(StudyPlan entity) {
    return StudyPlanModel(
      id: entity.id,
      title: entity.title,
      summary: entity.summary,
      timeframe: entity.timeframe,
      reasoning: entity.reasoning,
      actionItems: entity.actionItems,
      warnings: entity.warnings,
      confidenceScore: entity.confidenceScore,
      providerName: entity.providerName,
      createdAt: entity.createdAt,
      isSaved: entity.isSaved,
    );
  }
}
