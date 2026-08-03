import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/design_system/widgets/error_states/app_error_card.dart';
import '../../../../shared/widgets/base_scaffold.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../../domain/entities/academic_profile.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_bloc.dart';

import '../widgets/profile_card.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_skeleton.dart';
import '../widgets/theme_switch_card.dart';

class ProfileHomePage extends StatefulWidget {
  const ProfileHomePage({super.key});

  @override
  State<ProfileHomePage> createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;
    final titleColor = isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight;
    final subtitleColor = isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight;

    return BaseScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => context.go(RouteNames.dashboard),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_pin_rounded, color: primaryColor, size: 22),
                const SizedBox(width: 8),
                Text(
                  'My Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: titleColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: primaryColor),
            onPressed: () => context.push(RouteNames.profilePrivacySettings),
            tooltip: 'Privacy Settings',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProfileBloc>().add(const LoadProfileEvent());
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileFailureState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AppErrorCard(
                    message: state.message,
                    onRetry: () => context.read<ProfileBloc>().add(const LoadProfileEvent()),
                  ),
                ),
              );
            }

            if (state is! ProfileLoadedState) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ProfileSkeleton(height: 140),
                    SizedBox(height: 16),
                    ProfileSkeleton(height: 100),
                    SizedBox(height: 16),
                    ProfileSkeleton(height: 120),
                  ],
                ),
              );
            }

            final user = state.profile;
            final acad = state.academic;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 100),
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              child: Column(
                children: [
                  // User Header Card
                  ProfileHeader(
                    profile: user,
                    onEditAvatar: () => context.push(RouteNames.profileEdit),
                  ),

                  const SizedBox(height: 12),

                  // 2026 Dual Theme Toggling Switch Card
                  const ThemeSwitchCard(),

                  const SizedBox(height: 12),

                  // Quick Action Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _buildActionChip(
                          context,
                          icon: Icons.bar_chart_rounded,
                          label: 'Statistics',
                          onTap: () => context.push(RouteNames.profileStatisticsDashboard),
                        ),
                        const SizedBox(width: 8),
                        _buildActionChip(
                          context,
                          icon: Icons.emoji_events_rounded,
                          label: 'Achievements',
                          onTap: () => context.push(RouteNames.profileAchievements),
                        ),
                        const SizedBox(width: 8),
                        _buildActionChip(
                          context,
                          icon: Icons.link_rounded,
                          label: 'Accounts',
                          onTap: () => context.push(RouteNames.profileConnectedAccounts),
                        ),
                        const SizedBox(width: 8),
                        _buildActionChip(
                          context,
                          icon: Icons.security_rounded,
                          label: 'Security',
                          onTap: () => context.push(RouteNames.profileSecurityOverview),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Academic Profile Card
                  ProfileCard(
                    title: 'Academic Details',
                    icon: Icons.school_rounded,
                    onEdit: () => context.push(RouteNames.profileAcademic),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          acad.university,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: titleColor),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${acad.degree} • ${acad.branch}',
                          style: TextStyle(fontSize: 14, color: subtitleColor),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildInfoBadge(
                              context,
                              label: 'CGPA: ${acad.cgpa}',
                              color: const Color(0xFF10B981),
                            ),
                            const SizedBox(width: 8),
                            _buildInfoBadge(
                              context,
                              label: 'Year ${acad.currentYear} (Sem ${acad.semester})',
                              color: primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Personal Information Card
                  ProfileCard(
                    title: 'Personal Information',
                    icon: Icons.badge_outlined,
                    onEdit: () => context.push(RouteNames.profilePersonalInformation),
                    child: Column(
                      children: [
                        _buildDetailRow(context, icon: Icons.email_outlined, label: 'Email', value: user.email),
                        const Divider(height: 16),
                        _buildDetailRow(context, icon: Icons.location_on_outlined, label: 'Location', value: '${user.city ?? "San Francisco"}, ${user.country ?? "United States"}'),
                        const Divider(height: 16),
                        _buildDetailRow(context, icon: Icons.schedule_outlined, label: 'Timezone', value: user.timezone),
                      ],
                    ),
                  ),

                  // Account & Data Settings
                  ProfileCard(
                    title: 'Account & Privacy',
                    icon: Icons.shield_outlined,
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.download_outlined, color: primaryColor),
                          title: Text('Export My Data', style: TextStyle(fontWeight: FontWeight.w600, color: titleColor)),
                          trailing: Icon(Icons.chevron_right_rounded, color: subtitleColor),
                          onTap: () => context.push(RouteNames.profileExportData),
                        ),
                        const Divider(height: 8),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent),
                          title: const Text('Delete Account', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.redAccent)),
                          trailing: Icon(Icons.chevron_right_rounded, color: subtitleColor),
                          onTap: () => context.push(RouteNames.profileDeleteAccount),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionChip(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;
    final titleColor = isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? DesignColors.glassBorderDark : DesignColors.glassBorderLight,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: primaryColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBadge(BuildContext context, {required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, {required IconData icon, required String label, required String value}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight;
    final subtitleColor = isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight;

    return Row(
      children: [
        Icon(icon, size: 18, color: subtitleColor),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: subtitleColor, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: titleColor),
        ),
      ],
    );
  }
}

