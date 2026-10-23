import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  final double radius;
  final VoidCallback? onEdit;

  const AvatarWidget({
    super.key,
    this.avatarUrl,
    this.radius = 48,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: theme.colorScheme.primaryContainer,
          backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
              ? NetworkImage(avatarUrl!) as ImageProvider
              : null,
          child: (avatarUrl == null || avatarUrl!.isEmpty)
              ? Icon(Icons.person_rounded, size: radius * 1.1, color: theme.colorScheme.primary)
              : null,
        ),
        if (onEdit != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(
              radius: radius * 0.3,
              backgroundColor: theme.colorScheme.primary,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.camera_alt_rounded, size: radius * 0.32, color: Colors.white),
                onPressed: onEdit,
              ),
            ),
          ),
      ],
    );
  }
}
