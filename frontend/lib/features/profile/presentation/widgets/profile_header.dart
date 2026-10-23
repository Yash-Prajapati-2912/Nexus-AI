import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../../domain/entities/user_profile.dart';
import 'avatar_widget.dart';
import 'completion_indicator.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onEditAvatar;

  const ProfileHeader({super.key, required this.profile, this.onEditAvatar});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryGradient = isDark ? DesignColors.primaryGradientDark : DesignColors.primaryGradientLight;
    final titleColor = isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight;
    final subtitleColor = isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight;
    final glowColor = isDark ? DesignColors.accentPurpleDark.withValues(alpha: 0.4) : DesignColors.primaryLight.withValues(alpha: 0.25);

    return GlassCard(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: glowColor,
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: AvatarWidget(
              avatarUrl: profile.avatarUrl,
              radius: 46,
              onEdit: onEditAvatar,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            (profile.displayName.isNotEmpty && profile.displayName != 'User')
                ? profile.displayName
                : (profile.email.isNotEmpty ? profile.email.split('@').first : 'User'),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: titleColor,
              letterSpacing: -0.3,
            ),
          ),
          if (profile.username.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '@${profile.username.trim()}',
              style: TextStyle(
                fontSize: 13,
                color: subtitleColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.indigo.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? DesignColors.glassBorderDark : DesignColors.glassBorderLight,
                ),
              ),
              child: Text(
                profile.bio!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const SizedBox(height: 14),
          CompletionIndicator(percentage: profile.completionPercentage),
        ],
      ),
    ),
  );
  }
}

