import 'package:flutter/material.dart';

class RateResponseScreen extends StatelessWidget {
  const RateResponseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Response')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_rounded, size: 64, color: Colors.amber),
              const SizedBox(height: 16),
              const Text('Thank you for rating your AI Mentor response!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Chat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
