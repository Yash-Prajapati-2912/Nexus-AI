import 'package:flutter/material.dart';

class TrashPage extends StatelessWidget {
  const TrashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash'),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Empty Trash', style: TextStyle(color: Colors.redAccent))),
        ],
      ),
      body: const Center(child: Text('Soft-deleted items will be permanently removed in 30 days.')),
    );
  }
}
