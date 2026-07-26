import 'package:flutter/material.dart';

class VoiceMessageCard extends StatefulWidget {
  final String durationText;

  const VoiceMessageCard({super.key, this.durationText = '0:15'});

  @override
  State<VoiceMessageCard> createState() => _VoiceMessageCardState();
}

class _VoiceMessageCardState extends State<VoiceMessageCard> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded, size: 28, color: theme.colorScheme.primary),
            onPressed: () => setState(() => _isPlaying = !_isPlaying),
          ),
          const SizedBox(width: 8),
          Text(widget.durationText, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          const Icon(Icons.graphic_eq_rounded, color: Color(0xFF6366F1), size: 20),
        ],
      ),
    );
  }
}
