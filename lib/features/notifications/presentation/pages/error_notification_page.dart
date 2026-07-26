import 'package:flutter/material.dart';

class ErrorNotificationPage extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ErrorNotificationPage({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 64, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                message ?? 'Failed to sync notifications. Please check your internet connection.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (onRetry != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry Connection'),
                  onPressed: onRetry,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
