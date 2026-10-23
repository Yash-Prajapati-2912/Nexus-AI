import 'package:flutter/material.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_header.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_card.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_chart.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_table.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_badge.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const AdminHeader(
          category: 'OVERVIEW',
          title: 'Executive Platform Dashboard',
        ),
        const Row(
          children: [
            Expanded(
              child: AdminCard(
                title: 'Total Active Users',
                value: '42,850',
                subtitle: '+14.2% from last month',
                icon: Icons.people_outline,
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: AdminCard(
                title: 'AI Tokens Processed',
                value: '1.84 M',
                subtitle: '+28.4% token utilization',
                icon: Icons.auto_awesome,
                color: Colors.purple,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: AdminCard(
                title: 'Monthly Recurring Revenue',
                value: '\$124,500',
                subtitle: '+8.1% MRR growth',
                icon: Icons.attach_money,
                color: Colors.green,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: AdminCard(
                title: 'API Gateway Latency',
                value: '24 ms',
                subtitle: '99.98% Uptime',
                icon: Icons.speed,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: AdminChart(title: 'Realtime System Request Throughput (Req/sec)'),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('System Health', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text('Auth Gateway'),
                        subtitle: Text('Healthy • 12ms'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text('AI Inference Engine'),
                        subtitle: Text('Healthy • 45ms'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text('PostgreSQL Pool'),
                        subtitle: Text('Healthy • 5ms'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        AdminTable(
          title: 'Recent Audit Logs',
          columns: const [
            AdminTableColumn(title: 'Timestamp'),
            AdminTableColumn(title: 'Admin User'),
            AdminTableColumn(title: 'Action'),
            AdminTableColumn(title: 'Status'),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text('2026-07-26 19:25:01')),
              DataCell(Text('admin@nexusai.com')),
              DataCell(Text('UPDATE_AI_TOKEN_LIMIT')),
              DataCell(AdminBadge(label: 'SUCCESS', status: BadgeStatus.success)),
            ]),
            DataRow(cells: [
              DataCell(Text('2026-07-26 19:20:14')),
              DataCell(Text('moderator@nexusai.com')),
              DataCell(Text('SUSPEND_USER_ACCOUNT')),
              DataCell(AdminBadge(label: 'SUCCESS', status: BadgeStatus.success)),
            ]),
          ],
        ),
      ],
    );
  }
}
