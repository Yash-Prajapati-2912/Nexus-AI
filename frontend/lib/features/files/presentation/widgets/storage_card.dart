import 'package:flutter/material.dart';
import '../../domain/entities/storage_usage.dart';
import 'storage_indicator.dart';

class StorageCard extends StatelessWidget {
  final StorageUsage storage;

  const StorageCard({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StorageIndicator(usedBytes: storage.usedBytes, totalBytes: storage.totalBytes),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatItem(label: 'Total Files', value: '${storage.fileCount}'),
                _StatItem(label: 'Docs', value: '${(storage.documentsBytes / (1024 * 1024)).toStringAsFixed(0)} MB'),
                _StatItem(label: 'Images', value: '${(storage.imagesBytes / (1024 * 1024)).toStringAsFixed(0)} MB'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
