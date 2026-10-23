import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/design_system/widgets/avatars/app_avatar.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryGradient = isDark
        ? DesignColors.primaryGradientDark
        : DesignColors.primaryGradientLight;

    final rawName = user.fullName.trim();
    final isGeneric = rawName.isEmpty ||
        ['user', 'student', 'guest', 'null', 'undefined'].contains(rawName.toLowerCase());
    final firstName = isGeneric ? '' : rawName.split(' ').first;
    final greetingDisplay = firstName.isNotEmpty ? '$greeting, $firstName 👋' : '$greeting 👋';

    return GlassCard(
      onTap: () => context.push(RouteNames.profile),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Glowing Gradient Profile Ring with Inner Border Gap
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? const Color(0xFF6366F1) : const Color(0xFF818CF8)).withValues(alpha: 0.35),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
              ),
              child: AppAvatar(
                imageUrl: user.avatarUrl,
                name: user.fullName,
                radius: 24,
                isOnline: true,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: ShaderMask(
                    shaderCallback: (bounds) => primaryGradient.createShader(bounds),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        greetingDisplay,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 11,
                              color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                dateStr,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                                  fontFamily: 'Poppins',
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (isDark ? DesignColors.primaryDark : DesignColors.primaryLight).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 14,
                            color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
