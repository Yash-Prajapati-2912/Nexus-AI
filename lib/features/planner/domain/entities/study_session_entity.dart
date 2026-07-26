import 'package:equatable/equatable.dart';

class StudySessionEntity extends Equatable {
  final String id;
  final String subject;
  final int durationMinutes;
  final DateTime startTime;
  final bool isCompleted;

  const StudySessionEntity({
    required this.id,
    required this.subject,
    required this.durationMinutes,
    required this.startTime,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [
        id,
        subject,
        durationMinutes,
        startTime,
        isCompleted,
      ];
}
