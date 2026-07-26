import '../../domain/entities/calendar_event_entity.dart';

class CalendarEventModel {
  final String id;
  final String title;
  final String startTime;
  final String endTime;
  final String type;

  const CalendarEventModel({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.type,
  });

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      startTime: json['startTime'] as String? ?? DateTime.now().toIso8601String(),
      endTime: json['endTime'] as String? ?? DateTime.now().toIso8601String(),
      type: json['type'] as String? ?? 'event',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'startTime': startTime,
        'endTime': endTime,
        'type': type,
      };

  CalendarEventEntity toDomain() {
    return CalendarEventEntity(
      id: id,
      title: title,
      startTime: DateTime.tryParse(startTime) ?? DateTime.now(),
      endTime: DateTime.tryParse(endTime) ?? DateTime.now(),
      type: type,
    );
  }
}
