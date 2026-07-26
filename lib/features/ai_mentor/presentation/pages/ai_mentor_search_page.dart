import 'package:flutter/material.dart';

class AIMentorSearchPage extends StatefulWidget {
  const AIMentorSearchPage({super.key});

  @override
  State<AIMentorSearchPage> createState() => _AIMentorSearchPageState();
}

class _AIMentorSearchPageState extends State<AIMentorSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search conversations or messages...',
            border: InputBorder.none,
          ),
          onChanged: (val) => setState(() {}),
        ),
      ),
      body: _searchController.text.isEmpty
          ? const Center(child: Text('Type to search AI Mentor history...'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                Card(
                  child: ListTile(
                    leading: Icon(Icons.search_rounded),
                    title: Text('Midterm Prep Strategy'),
                    subtitle: Text('Matching message: "Tree algorithms"'),
                  ),
                ),
              ],
            ),
    );
  }
}
