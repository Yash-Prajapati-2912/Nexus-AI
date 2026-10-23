import 'package:equatable/equatable.dart';

/// Domain entity representing a Smart Recommendation.
class Recommendation extends Equatable {
  final String id;
  final String title;
  final String description;
  final String priority; // HIGH, MEDIUM, LOW
  final String category; // STUDY_TIME, BREAK, SUBJECT_PRIORITY, TASK_REORDER, TECHNIQUE
  final String? actionUrl;

  const Recommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.category,
    this.actionUrl,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        priority,
        category,
        actionUrl,
      ];
}
