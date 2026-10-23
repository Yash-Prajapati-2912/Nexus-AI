import 'package:equatable/equatable.dart';

/// Domain entity for AI Planner Request History / Bookmarks.
class AIHistoryItem extends Equatable {
  final String id;
  final String prompt;
  final String responseSummary;
  final String actionType; // GENERATE_PLAN, PRIORITISE, WORKLOAD, INSIGHTS, RISK
  final DateTime createdAt;
  final bool isBookmarked;

  const AIHistoryItem({
    required this.id,
    required this.prompt,
    required this.responseSummary,
    required this.actionType,
    required this.createdAt,
    this.isBookmarked = false,
  });

  AIHistoryItem copyWith({
    String? id,
    String? prompt,
    String? responseSummary,
    String? actionType,
    DateTime? createdAt,
    bool? isBookmarked,
  }) {
    return AIHistoryItem(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      responseSummary: responseSummary ?? this.responseSummary,
      actionType: actionType ?? this.actionType,
      createdAt: createdAt ?? this.createdAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  List<Object?> get props => [
        id,
        prompt,
        responseSummary,
        actionType,
        createdAt,
        isBookmarked,
      ];
}
