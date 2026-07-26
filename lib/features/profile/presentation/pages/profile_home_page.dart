import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/academic_profile.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_bloc.dart';

import '../widgets/profile_card.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_skeleton.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push(RouteNames.profilePrivacySettings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProfileBloc>().add(const LoadProfileEvent());
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ProfileSkeleton(height: 120),
                    SizedBox(height: 16),
                    ProfileSkeleton(height: 100),
                    SizedBox(height: 16),
                    ProfileSkeleton(height: 100),
                  ],
                ),
              );
            }

            final user = (state is ProfileLoadedState)
                ? state.profile
                : const UserProfile(
                    id: 'u1',
                    userId: 'usr1',
                    displayName: 'Alex Rivers',
                    username: 'alexrivers',
                    email: 'alex.rivers@stanford.edu',
                    bio: 'Computer Science Undergraduate',
                    timezone: 'PST',
                    language: 'en',
                    completionPercentage: 90,
                  );

            final acad = (state is ProfileLoadedState)
                ? state.academic
                : const AcademicProfile(
                    id: 'a1',
                    university: 'Stanford University',
                    college: 'School of Engineering',
                    degree: 'B.S. Computer Science',
                    branch: 'AI Architecture',
                    semester: 6,
                    currentYear: 3,
                    cgpa: 3.85,
                    graduationYear: 2027,
                    subjects: ['Data Structures', 'Machine Learning'],
                    skills: ['Flutter', 'Dart', 'NestJS'],
                    careerInterests: ['Full-Stack AI Software Engineering'],
                  );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ProfileHeader(
                    profile: user,
                    onEditAvatar: () => context.push(RouteNames.profileEdit),
                  ),

                  const SizedBox(height: 20),

                  // Quick Action Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.bar_chart_rounded, size: 16),
                        label: const Text('Statistics'),
                        onPressed: () => context.push(RouteNames.profileStatisticsDashboard),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.emoji_events_rounded, size: 16),
                        label: const Text('Achievements'),
                        onPressed: () => context.push(RouteNames.profileAchievements),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.link_rounded, size: 16),
                        label: const Text('Accounts'),
                        onPressed: () => context.push(RouteNames.profileConnectedAccounts),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.security_rounded, size: 16),
                        label: const Text('Security'),
                        onPressed: () => context.push(RouteNames.profileSecurityOverview),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  ProfileCard(
                    title: 'Academic Profile',
                    icon: Icons.school_rounded,
                    onEdit: () => context.push(RouteNames.profileAcademic),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(acad.university, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                        Text('${acad.degree} (${acad.branch})'),
                        const SizedBox(height: 4),
                        Text('CGPA: ${acad.cgpa} • Year ${acad.currentYear} (Semester ${acad.semester})', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                      ],
                    ),
                  ),

                  ProfileCard(
                    title: 'Personal Information',
                    icon: Icons.person_outline_rounded,
                    onEdit: () => context.push(RouteNames.profilePersonalInformation),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Country: ${user.country ?? "United States"}'),
                        Text('City: ${user.city ?? "San Francisco"}'),
                        Text('Timezone: ${user.timezone}'),
                      ],
                    ),
                  ),

                  ProfileCard(
                    title: 'Account & Data Settings',
                    icon: Icons.manage_accounts_rounded,
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.download_rounded),
                          title: const Text('Export My Data'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => context.push(RouteNames.profileExportData),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
                          title: const Text('Delete Account', style: TextStyle(color: Colors.redAccent)),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => context.push(RouteNames.profileDeleteAccount),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
