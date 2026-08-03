import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';

class PersonalInformationPage extends StatelessWidget {
  const PersonalInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Information')),
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
              _Tile(title: 'Full Name', value: user.displayName.isNotEmpty ? user.displayName : 'Student', icon: Icons.person_rounded),
              _Tile(title: 'Email Address', value: user.email.isNotEmpty ? user.email : 'Not provided', icon: Icons.email_rounded),
              _Tile(title: 'Username', value: '@${user.username}', icon: Icons.alternate_email_rounded),
              _Tile(title: 'Phone Number', value: user.phone ?? 'Not provided', icon: Icons.phone_rounded),
              _Tile(title: 'Date of Birth', value: dobStr, icon: Icons.cake_rounded),
              _Tile(title: 'Gender', value: user.gender ?? 'Not specified', icon: Icons.face_rounded),
              _Tile(title: 'Country', value: user.country ?? 'Not provided', icon: Icons.flag_rounded),
              _Tile(title: 'Timezone', value: user.timezone, icon: Icons.access_time_rounded),
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

  const _Tile({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: theme.textTheme.labelMedium),
        subtitle: Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
