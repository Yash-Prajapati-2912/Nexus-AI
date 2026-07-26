import 'package:flutter/material.dart';

class PermissionDeniedWidget extends StatelessWidget {
  final String permissionName;
  final VoidCallback onRequestPermission;

  const PermissionDeniedWidget({
    super.key,
    required this.permissionName,
    required this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.security_rounded, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('$permissionName Required', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Please grant $permissionName permission to use this feature.'),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRequestPermission, child: const Text('Grant Permission')),
        ],
      ),
    );
  }
}
