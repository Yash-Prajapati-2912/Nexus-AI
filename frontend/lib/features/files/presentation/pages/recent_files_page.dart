import 'package:flutter/material.dart';

class RecentFilesPage extends StatelessWidget {
  const RecentFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recent Files')),
      body: const Center(child: Text('Recent files list')),
    );
  }
}
