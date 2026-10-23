import 'package:flutter/material.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_header.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_card.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_table.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_badge.dart';

class AdminPlannerPage extends StatelessWidget {
  const AdminPlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const AdminHeader(
          category: 'SMART PLANNER MODULE',
          title: 'Global Study Tasks & Deadlines',
        ),
        const Row(
          children: [
            Expanded(
              child: AdminCard(
                title: 'Total Active Tasks',
                value: '184,200',
                subtitle: '82% completion rate',
                icon: Icons.task_alt,
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: AdminCard(
                title: 'AI Schedules Generated',
                value: '12,450',
                subtitle: 'Automated study plans',
                icon: Icons.calendar_month,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        AdminTable(
          title: 'Recent Planner Schedules',
          columns: const [
            AdminTableColumn(title: 'Task ID'),
            AdminTableColumn(title: 'Title'),
            AdminTableColumn(title: 'Subject'),
            AdminTableColumn(title: 'Priority'),
            AdminTableColumn(title: 'Status'),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text('tsk-991')),
              DataCell(Text('Organic Chemistry Midterm Revision')),
              DataCell(Text('Chemistry')),
              DataCell(Text('HIGH')),
              DataCell(AdminBadge(label: 'COMPLETED', status: BadgeStatus.success)),
            ]),
            DataRow(cells: [
              DataCell(Text('tsk-992')),
              DataCell(Text('Algorithms & Data Structures Assignment 3')),
              DataCell(Text('Computer Science')),
              DataCell(Text('URGENT')),
              DataCell(AdminBadge(label: 'IN_PROGRESS', status: BadgeStatus.warning)),
            ]),
          ],
        ),
      ],
    );
  }
}
