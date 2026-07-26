import 'package:flutter/material.dart';

class SavedMessagesPage extends StatelessWidget {
  const SavedMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved & Bookmarked Messages')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.bookmark_rounded, color: Color(0xFF6366F1)),
              title: Text('Tree Traversal Revision Formula', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Bookmarked from Midterm Prep Strategy session'),
            ),
          ),
        ],
      ),
    );
  }
}
