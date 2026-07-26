import 'package:flutter/material.dart';
import '../../domain/entities/priority_optimizer.dart';

class PriorityMatrixWidget extends StatelessWidget {
  final PriorityOptimizer optimizer;

  const PriorityMatrixWidget({super.key, required this.optimizer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Eisenhower Priority Matrix',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.3,
          children: [
            _buildQuadrant(
              context: context,
              title: 'Urgent & Important',
              subtitle: 'Do First',
              color: Colors.red.shade900.withAlpha(40),
              borderColor: Colors.redAccent,
              count: optimizer.urgentDeadlines.length,
            ),
            _buildQuadrant(
              context: context,
              title: 'Not Urgent & Important',
              subtitle: 'Schedule',
              color: Colors.blue.shade900.withAlpha(40),
              borderColor: Colors.blueAccent,
              count: optimizer.highestPriorityTasks.length,
            ),
            _buildQuadrant(
              context: context,
              title: 'Urgent & Not Important',
              subtitle: 'Delegate / Quick',
              color: Colors.orange.shade900.withAlpha(40),
              borderColor: Colors.orangeAccent,
              count: 2,
            ),
            _buildQuadrant(
              context: context,
              title: 'Not Urgent & Not Important',
              subtitle: 'Eliminate',
              color: Colors.green.shade900.withAlpha(40),
              borderColor: Colors.lightGreenAccent,
              count: 1,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuadrant({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Color color,
    required Color borderColor,
    required int count,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor.withAlpha(120), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: borderColor,
                ),
              ),
              CircleAvatar(
                radius: 12,
                backgroundColor: borderColor.withAlpha(40),
                child: Text(
                  '$count',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: borderColor),
                ),
              ),
            ],
          ),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
