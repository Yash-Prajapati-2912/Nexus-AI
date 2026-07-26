import 'package:flutter/material.dart';
import '../../domain/entities/user_profile.dart';
import 'avatar_widget.dart';
import 'completion_indicator.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onEditAvatar;

  const ProfileHeader({super.key, required this.profile, this.onEditAvatar});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        AvatarWidget(
          avatarUrl: profile.avatarUrl,
          radius: 50,
          onEdit: onEditAvatar,
        ),
        const SizedBox(height: 12),
        Text(
          profile.displayName,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          '@${profile.username} • ${profile.email}',
          style: theme.textTheme.bodySmall,
        ),
        if (profile.bio != null && profile.bio!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(profile.bio!, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
        ],
        const SizedBox(height: 10),
        CompletionIndicator(percentage: profile.completionPercentage),
      ],
    );
  }
}
