import 'package:flutter/material.dart';

class SharedFilesPage extends StatelessWidget {
  const SharedFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shared Files')),
      body: const Center(child: Text('Files shared with me or publicly linked')),
    );
  }
}
