import 'package:flutter/material.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_header.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_card.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_chart.dart';

class AdminAnalyticsPage extends StatelessWidget {
  const AdminAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const AdminHeader(
          category: 'TELEMETRY & HEALTH',
          title: 'System Analytics & Latency Graphs',
        ),
        const Row(
          children: [
            Expanded(
              child: AdminCard(
                title: 'Avg API Response',
                value: '18 ms',
                subtitle: '-4ms performance improvement',
                icon: Icons.flash_on,
                color: Colors.green,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: AdminCard(
                title: 'Error Rate (5xx)',
                value: '0.01%',
                subtitle: 'Within 99.99% SLA limit',
                icon: Icons.report_problem_outlined,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const AdminChart(title: 'API Gateway Latency Distribution over 24 Hours (ms)'),
      ],
    );
  }
}
