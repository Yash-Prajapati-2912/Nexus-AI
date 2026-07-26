import 'package:flutter/material.dart';

class FilterFilesPage extends StatelessWidget {
  const FilterFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filter Files')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(title: Text('Filter by File Type: Images, Documents, Videos, Audio')),
          ListTile(title: Text('Filter by Module: Planner, Finance, AI Mentor')),
          ListTile(title: Text('Filter by Date: Today, Past Week, Past Month')),
        ],
      ),
    );
  }
}
