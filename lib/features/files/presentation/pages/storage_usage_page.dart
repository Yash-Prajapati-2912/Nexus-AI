import 'package:flutter/material.dart';
import '../../domain/entities/storage_usage.dart';
import '../widgets/storage_card.dart';

class StorageUsagePage extends StatelessWidget {
  const StorageUsagePage({super.key});

  final StorageUsage _sampleStorage = const StorageUsage(
    usedBytes: 145000000,
    totalBytes: 10737418240,
    imagesBytes: 45000000,
    documentsBytes: 65000000,
    mediaBytes: 25000000,
    otherBytes: 10000000,
    fileCount: 32,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Storage Usage')),
      body: ListView(
        children: [
          StorageCard(storage: _sampleStorage),
        ],
      ),
    );
  }
}
