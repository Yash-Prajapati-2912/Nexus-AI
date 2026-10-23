import 'package:flutter/material.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_header.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_table.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_badge.dart';

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AdminHeader(
          category: 'USER MANAGEMENT',
          title: 'Registered Users & Accounts',
          actions: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Provision User'),
              onPressed: () {},
            ),
          ],
        ),
        AdminTable(
          title: 'All User Accounts',
          columns: const [
            AdminTableColumn(title: 'ID'),
            AdminTableColumn(title: 'Name'),
            AdminTableColumn(title: 'Email'),
            AdminTableColumn(title: 'Role'),
            AdminTableColumn(title: 'Status'),
            AdminTableColumn(title: 'Actions'),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text('usr-101')),
              const DataCell(Text('Alex Morgan')),
              const DataCell(Text('alex.morgan@university.edu')),
              const DataCell(Text('STUDENT')),
              const DataCell(AdminBadge(label: 'ACTIVE', status: BadgeStatus.success)),
              DataCell(Row(
                children: [
                  IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.block, size: 20, color: Colors.red), onPressed: () {}),
                ],
              )),
            ]),
            DataRow(cells: [
              const DataCell(Text('usr-102')),
              const DataCell(Text('Prof. Marcus Vance')),
              const DataCell(Text('m.vance@stanford.edu')),
              const DataCell(Text('FACULTY')),
              const DataCell(AdminBadge(label: 'ACTIVE', status: BadgeStatus.success)),
              DataCell(Row(
                children: [
                  IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.block, size: 20, color: Colors.red), onPressed: () {}),
                ],
              )),
            ]),
          ],
        ),
      ],
    );
  }
}
