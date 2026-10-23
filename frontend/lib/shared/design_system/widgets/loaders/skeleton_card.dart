import 'package:flutter/material.dart';
import 'shimmer_loader.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoader(width: 120, height: 16),
          SizedBox(height: 8),
          ShimmerLoader(width: double.infinity, height: 12),
          SizedBox(height: 4),
          ShimmerLoader(width: 200, height: 12),
        ],
      ),
    );
  }
}
