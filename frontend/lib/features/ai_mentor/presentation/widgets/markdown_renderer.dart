import 'package:flutter/material.dart';

class MarkdownRenderer extends StatelessWidget {
  final String text;

  const MarkdownRenderer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lines = text.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.trim().isEmpty) {
          return const SizedBox(height: 6);
        }

        if (line.startsWith('# ')) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Text(
              line.substring(2),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
          );
        } else if (line.startsWith('## ')) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              line.substring(3),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
          );
        } else if (line.startsWith('### ')) {
          return Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 2),
            child: Text(
              line.substring(4),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
          );
        } else if (line.trim().startsWith('- ') || line.trim().startsWith('* ')) {
          final content = line.trim().substring(2);
          return Padding(
            padding: const EdgeInsets.only(left: 4, top: 3, bottom: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigoAccent,
                    fontSize: 14,
                  ),
                ),
                Expanded(child: _buildRichLine(content, isDark)),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: _buildRichLine(line, isDark),
          );
        }
      }).toList(),
    );
  }

  Widget _buildRichLine(String line, bool isDark) {
    // Parse inline bold text (**bold**)
    final parts = line.split('**');
    if (parts.length <= 1) {
      return Text(
        line,
        style: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: isDark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
          fontFamily: 'Poppins',
        ),
      );
    }

    final spans = <TextSpan>[];
    for (int i = 0; i < parts.length; i++) {
      final isBold = i % 2 == 1;
      spans.add(
        TextSpan(
          text: parts[i],
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold
                ? (isDark ? Colors.white : Colors.black)
                : (isDark ? Colors.white.withValues(alpha: 0.9) : Colors.black87),
          ),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          height: 1.45,
          fontFamily: 'Poppins',
        ),
        children: spans,
      ),
    );
  }
}
