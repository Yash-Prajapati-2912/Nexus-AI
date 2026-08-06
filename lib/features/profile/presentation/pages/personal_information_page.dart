import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/location_service.dart';
import '../../../../router/route_names.dart';
import '../bloc/profile_bloc.dart';

class PersonalInformationPage extends StatelessWidget {
  const PersonalInformationPage({super.key});

  Future<void> _autoDetectTimezone(BuildContext context) async {
    final tz = await LocationService.requestLocationAndTimezone(context);
    if (tz != null && context.mounted) {
      context.read<ProfileBloc>().add(UpdateUserProfileEvent({'timezone': tz}));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission granted! Timezone updated to $tz')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location_rounded),
            onPressed: () => _autoDetectTimezone(context),
            tooltip: 'Auto-detect Timezone',
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(RouteNames.profileEdit),
            tooltip: 'Edit Information',
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is! ProfileLoadedState) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = state.profile;
          final dobStr = user.dateOfBirth != null
              ? '${user.dateOfBirth!.day}/${user.dateOfBirth!.month}/${user.dateOfBirth!.year}'
              : 'Not provided';

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _Tile(title: 'Full Name', value: user.displayName.isNotEmpty ? user.displayName : 'Not provided', icon: Icons.person_rounded),
              _Tile(title: 'Email Address', value: user.email.isNotEmpty ? user.email : 'Not provided', icon: Icons.email_rounded),
              _Tile(title: 'Username', value: user.username.isNotEmpty ? '@${user.username}' : 'Not provided', icon: Icons.alternate_email_rounded),
              _Tile(title: 'Phone Number', value: user.phone ?? 'Not provided', icon: Icons.phone_rounded),
              _Tile(title: 'Date of Birth', value: dobStr, icon: Icons.cake_rounded),
              _Tile(title: 'Gender', value: user.gender ?? 'Not specified', icon: Icons.face_rounded),
              _Tile(title: 'City', value: user.city != null && user.city!.isNotEmpty ? user.city! : 'Not provided', icon: Icons.location_city_rounded),
              _Tile(title: 'Country', value: user.country != null && user.country!.isNotEmpty ? user.country! : 'Not provided', icon: Icons.flag_rounded),
              _Tile(
                title: 'Timezone',
                value: user.timezone,
                icon: Icons.access_time_rounded,
                trailing: IconButton(
                  icon: const Icon(Icons.my_location_rounded),
                  onPressed: () => _autoDetectTimezone(context),
                  tooltip: 'Auto-detect Location & Timezone',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Widget? trailing;

  const _Tile({
    required this.title,
    required this.value,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: theme.textTheme.labelMedium),
        subtitle: Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        trailing: trailing,
      ),
    );
  }
}
