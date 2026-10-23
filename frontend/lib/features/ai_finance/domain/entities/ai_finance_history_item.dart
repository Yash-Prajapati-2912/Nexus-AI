import 'package:equatable/equatable.dart';

/// Domain entity for AI Financial Reports History & Saved Insights.
class AIFinanceHistoryItem extends Equatable {
  final String id;
  final String title;
  final String reportType; // EXECUTIVE_SUMMARY, SPENDING_ANALYSIS, FORECAST, SAVINGS_PLAN
  final DateTime createdAt;
  final String summarySnippet;
  final bool isBookmarked;

  const AIFinanceHistoryItem({
    required this.id,
    required this.title,
    required this.reportType,
    required this.createdAt,
    required this.summarySnippet,
    this.isBookmarked = false,
  });

  @override
  List<Object?> get props => [id, title, reportType, createdAt, summarySnippet, isBookmarked];
}
