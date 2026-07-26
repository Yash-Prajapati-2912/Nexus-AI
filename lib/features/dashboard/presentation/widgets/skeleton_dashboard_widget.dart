import 'package:flutter/material.dart';
import '../../../../shared/design_system/widgets/loaders/shimmer_loader.dart';
import '../../../../shared/design_system/widgets/loaders/skeleton_card.dart';

class SkeletonDashboardWidget extends StatelessWidget {
  const SkeletonDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              ShimmerLoader(width: 56, height: 56, borderRadius: 28),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoader(width: 180, height: 18),
                  SizedBox(height: 6),
                  ShimmerLoader(width: 120, height: 12),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          SkeletonCard(),
          SizedBox(height: 16),
          SkeletonCard(),
          SizedBox(height: 16),
          SkeletonCard(),
        ],
      ),
    );
  }
}
