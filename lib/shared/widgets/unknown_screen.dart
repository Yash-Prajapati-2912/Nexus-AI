import 'package:flutter/material.dart';

/// 404 Unknown Route Screen.
class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 72, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              '404 - Screen Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text('The page you are looking for does not exist.'),
          ],
        ),
      ),
    );
  }
}
