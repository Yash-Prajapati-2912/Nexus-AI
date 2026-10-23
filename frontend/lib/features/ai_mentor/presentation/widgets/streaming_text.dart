import 'dart:async';
import 'package:flutter/material.dart';
import 'markdown_renderer.dart';

class StreamingText extends StatefulWidget {
  final String fullText;

  const StreamingText({super.key, required this.fullText});

  @override
  State<StreamingText> createState() => _StreamingTextState();
}

class _StreamingTextState extends State<StreamingText> {
  String _displayedText = '';
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startStreaming();
  }

  void _startStreaming() {
    _timer?.cancel();
    _displayedText = '';
    _currentIndex = 0;

    _timer = Timer.periodic(const Duration(milliseconds: 25), (t) {
      if (_currentIndex < widget.fullText.length) {
        final nextCharCount = (_currentIndex + 2).clamp(0, widget.fullText.length);
        if (mounted) {
          setState(() {
            _displayedText = widget.fullText.substring(0, nextCharCount);
            _currentIndex = nextCharCount;
          });
        }
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownRenderer(text: _displayedText);
  }
}
