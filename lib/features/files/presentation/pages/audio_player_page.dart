import 'package:flutter/material.dart';
import '../../domain/entities/file_item.dart';

class AudioPlayerPage extends StatelessWidget {
  final FileItem? file;

  const AudioPlayerPage({super.key, this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(file?.fileName ?? 'Audio Player')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 44,
              backgroundColor: Color(0xFF10B981),
              child: Icon(Icons.audiotrack_rounded, size: 44, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(file?.fileName ?? 'Lecture_Audio.mp3', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.replay_10_rounded), onPressed: () {}),
                IconButton(icon: const Icon(Icons.play_circle_filled_rounded, size: 48, color: Color(0xFF10B981)), onPressed: () {}),
                IconButton(icon: const Icon(Icons.forward_10_rounded), onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
