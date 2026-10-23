import 'package:flutter/material.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_header.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_card.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_table.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_badge.dart';

class AdminAIModulesPage extends StatelessWidget {
  const AdminAIModulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const AdminHeader(
          category: 'ARTIFICIAL INTELLIGENCE',
          title: 'AI Models & Token Limits',
        ),
        const Row(
          children: [
            Expanded(
              child: AdminCard(
                title: 'Active Models',
                value: '4 LLMs',
                subtitle: 'GPT-4o, Claude 3.5, Gemini 1.5 Pro',
                icon: Icons.psychology,
                color: Colors.purple,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: AdminCard(
                title: 'Monthly Token Quota',
                value: '10 M Tokens',
                subtitle: '18.4% utilized',
                icon: Icons.data_usage,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        AdminTable(
          title: 'Configured AI Agents',
          columns: const [
            AdminTableColumn(title: 'Agent Name'),
            AdminTableColumn(title: 'Model Endpoint'),
            AdminTableColumn(title: 'Temperature'),
            AdminTableColumn(title: 'Max Tokens'),
            AdminTableColumn(title: 'Status'),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text('AI Smart Planner')),
              DataCell(Text('gpt-4o-mini')),
              DataCell(Text('0.2')),
              DataCell(Text('2048')),
              DataCell(AdminBadge(label: 'ONLINE', status: BadgeStatus.success)),
            ]),
            DataRow(cells: [
              DataCell(Text('AI Financial Advisor')),
              DataCell(Text('gemini-1.5-pro')),
              DataCell(Text('0.1')),
              DataCell(Text('4096')),
              DataCell(AdminBadge(label: 'ONLINE', status: BadgeStatus.success)),
            ]),
            DataRow(cells: [
              DataCell(Text('AI Academic Mentor')),
              DataCell(Text('claude-3-5-sonnet')),
              DataCell(Text('0.7')),
              DataCell(Text('8192')),
              DataCell(AdminBadge(label: 'ONLINE', status: BadgeStatus.success)),
            ]),
          ],
        ),
      ],
    );
  }
}
