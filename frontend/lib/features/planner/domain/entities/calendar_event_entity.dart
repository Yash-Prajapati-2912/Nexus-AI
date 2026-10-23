import 'package:equatable/equatable.dart';

class CalendarEventEntity extends Equatable {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String type;

  const CalendarEventEntity({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, startTime, endTime, type];
}
