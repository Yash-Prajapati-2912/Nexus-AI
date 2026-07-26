import 'package:flutter/material.dart';

class PersonalInformationPage extends StatelessWidget {
  const PersonalInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Personal Information')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _Tile(title: 'Full Name', value: 'Alex Rivers', icon: Icons.person_rounded),
          _Tile(title: 'Email Address', value: 'alex.rivers@stanford.edu', icon: Icons.email_rounded),
          _Tile(title: 'Phone Number', value: '+1 (555) 234-5678', icon: Icons.phone_rounded),
          _Tile(title: 'Date of Birth', value: 'October 14, 2003', icon: Icons.cake_rounded),
          _Tile(title: 'Gender', value: 'Male', icon: Icons.face_rounded),
          _Tile(title: 'Country', value: 'United States', icon: Icons.flag_rounded),
          _Tile(title: 'Timezone', value: 'PST (Pacific Standard Time)', icon: Icons.access_time_rounded),
        ],
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
