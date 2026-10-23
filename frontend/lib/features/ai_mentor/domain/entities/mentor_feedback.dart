import 'package:equatable/equatable.dart';

/// Domain entity representing user feedback for an AI response.
class MentorFeedback extends Equatable {
  final String messageId;
  final int rating; // 1 to 5
  final String feedbackType; // HELPFUL, INACCURATE, OFF_TOPIC, INCOMPLETE
  final String comment;
  final String category;

  const MentorFeedback({
    required this.messageId,
    required this.rating,
    required this.feedbackType,
    required this.comment,
    required this.category,
  });

  @override
  List<Object?> get props => [messageId, rating, feedbackType, comment, category];
}
