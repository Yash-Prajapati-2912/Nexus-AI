import 'package:flutter/material.dart';
import '../../domain/entities/calendar_event_entity.dart';

class CalendarTile extends StatelessWidget {
  final CalendarEventEntity event;

  const CalendarTile({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.event_note_rounded, color: Colors.blue),
      title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('${event.startTime.hour}:${event.startTime.minute.toString().padLeft(2, '0')} - ${event.endTime.hour}:${event.endTime.minute.toString().padLeft(2, '0')}'),
    );
  }
}
