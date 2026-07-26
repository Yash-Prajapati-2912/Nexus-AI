import '../../domain/entities/mentor_feedback.dart';

class MentorFeedbackModel extends MentorFeedback {
  const MentorFeedbackModel({
    required super.messageId,
    required super.rating,
    required super.feedbackType,
    required super.comment,
    required super.category,
  });

  factory MentorFeedbackModel.fromJson(Map<String, dynamic> json) {
    return MentorFeedbackModel(
      messageId: json['messageId'] as String? ?? '',
      rating: json['rating'] as int? ?? 5,
      feedbackType: json['feedbackType'] as String? ?? 'HELPFUL',
      comment: json['comment'] as String? ?? '',
      category: json['category'] as String? ?? 'GENERAL',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'rating': rating,
      'feedbackType': feedbackType,
      'comment': comment,
      'category': category,
    };
  }
}
