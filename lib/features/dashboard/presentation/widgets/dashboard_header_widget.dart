import 'package:flutter/material.dart';
import '../../../../shared/design_system/widgets/avatars/app_avatar.dart';
import '../../../authentication/domain/entities/user_entity.dart';

class DashboardHeaderWidget extends StatelessWidget {
  final UserEntity user;

  const DashboardHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';

    final dateStr = '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';

    return Row(
      children: [
        AppAvatar(
          imageUrl: user.avatarUrl,
          name: user.fullName,
          radius: 28,
          isOnline: true,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, ${user.fullName.split(' ').first}!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                'Today is $dateStr',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
