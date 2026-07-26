import 'package:flutter/material.dart';

class SearchFilesPage extends StatefulWidget {
  const SearchFilesPage({super.key});

  @override
  State<SearchFilesPage> createState() => _SearchFilesPageState();
}

class _SearchFilesPageState extends State<SearchFilesPage> {
  final TextEditingController _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _queryController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search files by name, ext, or folder...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: const Center(child: Text('Type to search files...')),
    );
  }
}
