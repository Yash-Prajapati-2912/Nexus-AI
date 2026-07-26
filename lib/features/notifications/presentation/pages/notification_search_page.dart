import 'package:flutter/material.dart';

class NotificationSearchPage extends StatefulWidget {
  const NotificationSearchPage({super.key});

  @override
  State<NotificationSearchPage> createState() => _NotificationSearchPageState();
}

class _NotificationSearchPageState extends State<NotificationSearchPage> {
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
            hintText: 'Search notifications & activities...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: const Center(child: Text('Type to search notifications...')),
    );
  }
}
