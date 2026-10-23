import 'package:flutter/material.dart';
import '../../../../shared/design_system/widgets/cards/app_card.dart';
import '../../domain/entities/study_session_entity.dart';

class StudySessionCard extends StatelessWidget {
  final StudySessionEntity session;

  const StudySessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          const Icon(Icons.timer_rounded, color: Colors.indigo),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.subject, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                Text('${session.durationMinutes} mins', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Icon(
            session.isCompleted ? Icons.check_circle_rounded : Icons.pending_rounded,
            color: session.isCompleted ? Colors.green : Colors.orange,
          ),
        ],
      ),
    );
  }
}
