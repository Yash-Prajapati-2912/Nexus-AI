import '../../domain/entities/study_session_entity.dart';

class StudySessionModel {
  final String id;
  final String subject;
  final int durationMinutes;
  final String startTime;
  final bool isCompleted;

  const StudySessionModel({
    required this.id,
    required this.subject,
    required this.durationMinutes,
    required this.startTime,
    required this.isCompleted,
  });

  factory StudySessionModel.fromJson(Map<String, dynamic> json) {
    return StudySessionModel(
      id: json['id'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      startTime: json['startTime'] as String? ?? DateTime.now().toIso8601String(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject,
        'durationMinutes': durationMinutes,
        'startTime': startTime,
        'isCompleted': isCompleted,
      };

  factory StudySessionModel.fromDomain(StudySessionEntity entity) {
    return StudySessionModel(
      id: entity.id,
      subject: entity.subject,
      durationMinutes: entity.durationMinutes,
      startTime: entity.startTime.toIso8601String(),
      isCompleted: entity.isCompleted,
    );
  }

  StudySessionEntity toDomain() {
    return StudySessionEntity(
      id: id,
      subject: subject,
      durationMinutes: durationMinutes,
      startTime: DateTime.tryParse(startTime) ?? DateTime.now(),
      isCompleted: isCompleted,
    );
  }
}
