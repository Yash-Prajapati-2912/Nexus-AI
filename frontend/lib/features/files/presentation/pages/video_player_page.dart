import 'package:flutter/material.dart';
import '../../domain/entities/file_item.dart';

class VideoPlayerPage extends StatelessWidget {
  final FileItem? file;

  const VideoPlayerPage({super.key, this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white, title: Text(file?.fileName ?? 'Video Player')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_fill_rounded, size: 80, color: Colors.purpleAccent),
            SizedBox(height: 16),
            Text('Streaming Video Recording...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
