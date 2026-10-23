import 'package:flutter/material.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_header.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_table.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_badge.dart';

class AdminNotificationsPage extends StatelessWidget {
  const AdminNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AdminHeader(
          category: 'PUSH NOTIFICATIONS',
          title: 'Broadcast Communication Composer',
          actions: [
            ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text('New Broadcast Notification'),
              onPressed: () {},
            ),
          ],
        ),
        AdminTable(
          title: 'Recent Broadcast History',
          columns: const [
            AdminTableColumn(title: 'Broadcast ID'),
            AdminTableColumn(title: 'Title'),
            AdminTableColumn(title: 'Target Audience'),
            AdminTableColumn(title: 'Sent Count'),
            AdminTableColumn(title: 'Status'),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text('bc-401')),
              DataCell(Text('System Maintenance Notice')),
              DataCell(Text('ALL_USERS')),
              DataCell(Text('42,850')),
              DataCell(AdminBadge(label: 'SENT', status: BadgeStatus.success)),
            ]),
            DataRow(cells: [
              DataCell(Text('bc-402')),
              DataCell(Text('New AI Academic Mentor Release')),
              DataCell(Text('PREMIUM_USERS')),
              DataCell(Text('14,200')),
              DataCell(AdminBadge(label: 'SENT', status: BadgeStatus.success)),
            ]),
          ],
        ),
      ],
    );
  }
}
