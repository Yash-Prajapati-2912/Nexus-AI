import 'package:flutter/material.dart';

class FileBadge extends StatelessWidget {
  final String extension;

  const FileBadge({super.key, required this.extension});

  @override
  Widget build(BuildContext context) {
    Color col;
    final ext = extension.toUpperCase();
    switch (ext) {
      case 'PDF':
        col = Colors.redAccent;
        break;
      case 'PNG':
      case 'JPG':
      case 'JPEG':
      case 'WEBP':
        col = Colors.blueAccent;
        break;
      case 'DOC':
      case 'DOCX':
        col = Colors.indigoAccent;
        break;
      case 'XLS':
      case 'XLSX':
      case 'CSV':
        col = const Color(0xFF10B981);
        break;
      case 'MP4':
      case 'MKV':
      case 'MOV':
        col = Colors.purpleAccent;
        break;
      case 'ZIP':
      case 'RAR':
        col = Colors.orangeAccent;
        break;
      default:
        col = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: col.withAlpha(30),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        ext,
        style: TextStyle(color: col, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
