import 'package:equatable/equatable.dart';

/// Domain entity representing suggested prompts & categories.
class PromptTemplate extends Equatable {
  final String id;
  final String title;
  final String category; // STUDY, FINANCE, CAREER, PRODUCTIVITY, MOTIVATIONAL
  final String promptText;
  final bool isFavorite;
  final int usageCount;

  const PromptTemplate({
    required this.id,
    required this.title,
    required this.category,
    required this.promptText,
    this.isFavorite = false,
    this.usageCount = 0,
  });

  @override
  List<Object?> get props => [id, title, category, promptText, isFavorite, usageCount];
}
