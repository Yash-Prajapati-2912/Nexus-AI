import 'package:flutter/material.dart';

class SavedInsightsPage extends StatelessWidget {
  const SavedInsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Insights & Bookmarks')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.bookmark_rounded, color: Color(0xFF6366F1)),
              title: Text('Meal Prep Savings Plan (₹800/mo)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Saved on July 20, 2026'),
            ),
          ),
        ],
      ),
    );
  }
}
