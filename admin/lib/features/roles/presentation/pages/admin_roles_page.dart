import 'package:flutter/material.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_header.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_table.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_badge.dart';

class AdminRolesPage extends StatelessWidget {
  const AdminRolesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AdminHeader(
          category: 'ACCESS CONTROL',
          title: 'Roles & Permission Matrix',
          actions: [
            ElevatedButton.icon(
              icon: const Icon(Icons.security),
              label: const Text('Create Role'),
              onPressed: () {},
            ),
          ],
        ),
        AdminTable(
          title: 'System Roles',
          columns: const [
            AdminTableColumn(title: 'Role Name'),
            AdminTableColumn(title: 'Assigned Users'),
            AdminTableColumn(title: 'Permissions'),
            AdminTableColumn(title: 'Status'),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text('SuperAdmin')),
              DataCell(Text('3')),
              DataCell(Text('ALL_PERMISSIONS')),
              DataCell(AdminBadge(label: 'SYSTEM', status: BadgeStatus.info)),
            ]),
            DataRow(cells: [
              DataCell(Text('Moderator')),
              DataCell(Text('12')),
              DataCell(Text('MANAGE_USERS, SEND_NOTIFICATIONS')),
              DataCell(AdminBadge(label: 'ACTIVE', status: BadgeStatus.success)),
            ]),
          ],
        ),
      ],
    );
  }
}
