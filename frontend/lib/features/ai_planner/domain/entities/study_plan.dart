import 'package:equatable/equatable.dart';

/// Domain entity representing an AI Generated Study Plan Action Item.
class ActionItem extends Equatable {
  final int step;
  final String title;
  final int allocatedMinutes;
  final DateTime targetDate;
  final String category;

  const ActionItem({
    required this.step,
    required this.title,
    required this.allocatedMinutes,
    required this.targetDate,
    required this.category,
  });

  @override
  List<Object?> get props => [step, title, allocatedMinutes, targetDate, category];
}

/// Domain entity representing a complete AI Study Plan.
class StudyPlan extends Equatable {
  final String id;
  final String title;
  final String summary;
  final String timeframe; // daily, weekly, monthly
  final List<String> reasoning;
  final List<ActionItem> actionItems;
  final List<String> warnings;
  final double confidenceScore;
  final String providerName;
  final DateTime createdAt;
  final bool isSaved;

  const StudyPlan({
    required this.id,
    required this.title,
    required this.summary,
    required this.timeframe,
    required this.reasoning,
    required this.actionItems,
    required this.warnings,
    required this.confidenceScore,
    required this.providerName,
    required this.createdAt,
    this.isSaved = false,
  });

  StudyPlan copyWith({
    String? id,
    String? title,
    String? summary,
    String? timeframe,
    List<String>? reasoning,
    List<ActionItem>? actionItems,
    List<String>? warnings,
    double? confidenceScore,
    String? providerName,
    DateTime? createdAt,
    bool? isSaved,
  }) {
    return StudyPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      timeframe: timeframe ?? this.timeframe,
      reasoning: reasoning ?? this.reasoning,
      actionItems: actionItems ?? this.actionItems,
      warnings: warnings ?? this.warnings,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      providerName: providerName ?? this.providerName,
      createdAt: createdAt ?? this.createdAt,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        summary,
        timeframe,
        reasoning,
        actionItems,
        warnings,
        confidenceScore,
        providerName,
        createdAt,
        isSaved,
      ];
}
