import 'package:flutter/material.dart';
import 'app_avatar.dart';

class EditableAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final VoidCallback onEdit;

  const EditableAvatar({
    super.key,
    this.imageUrl,
    this.name,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppAvatar(imageUrl: imageUrl, name: name, radius: 48),
        Positioned(
          right: 0,
          bottom: 0,
          child: InkWell(
            onTap: onEdit,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
