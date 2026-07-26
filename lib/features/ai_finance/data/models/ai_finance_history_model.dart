import '../../domain/entities/ai_finance_history_item.dart';

class AIFinanceHistoryModel extends AIFinanceHistoryItem {
  const AIFinanceHistoryModel({
    required super.id,
    required super.title,
    required super.reportType,
    required super.createdAt,
    required super.summarySnippet,
    super.isBookmarked,
  });

  factory AIFinanceHistoryModel.fromJson(Map<String, dynamic> json) {
    return AIFinanceHistoryModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'AI Report',
      reportType: json['reportType'] as String? ?? 'EXECUTIVE_SUMMARY',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
      summarySnippet: json['summarySnippet'] as String? ?? json['summary'] as String? ?? 'Financial report summary.',
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'reportType': reportType,
      'createdAt': createdAt.toIso8601String(),
      'summarySnippet': summarySnippet,
      'isBookmarked': isBookmarked,
    };
  }

  factory AIFinanceHistoryModel.fromEntity(AIFinanceHistoryItem entity) {
    return AIFinanceHistoryModel(
      id: entity.id,
      title: entity.title,
      reportType: entity.reportType,
      createdAt: entity.createdAt,
      summarySnippet: entity.summarySnippet,
      isBookmarked: entity.isBookmarked,
    );
  }
}
