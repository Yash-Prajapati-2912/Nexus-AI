import 'package:flutter/material.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_header.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_table.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_badge.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const AdminHeader(
          category: 'GLOBAL CONFIGURATION',
          title: 'System Environment & Feature Flags',
        ),
        AdminTable(
          title: 'System Feature Flags',
          columns: const [
            AdminTableColumn(title: 'Flag Key'),
            AdminTableColumn(title: 'Description'),
            AdminTableColumn(title: 'Environment'),
            AdminTableColumn(title: 'State'),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text('ai_mentor_v2_beta')),
              DataCell(Text('Enable Claude 3.5 Sonnet conversational mentor')),
              DataCell(Text('PRODUCTION')),
              DataCell(AdminBadge(label: 'ENABLED', status: BadgeStatus.success)),
            ]),
            DataRow(cells: [
              DataCell(Text('biometric_passkeys')),
              DataCell(Text('Enable WebAuthn hardware passkeys')),
              DataCell(Text('PRODUCTION')),
              DataCell(AdminBadge(label: 'ENABLED', status: BadgeStatus.success)),
            ]),
            DataRow(cells: [
              DataCell(Text('maintenance_mode')),
              DataCell(Text('Lock mobile app client access for system maintenance')),
              DataCell(Text('GLOBAL')),
              DataCell(AdminBadge(label: 'DISABLED', status: BadgeStatus.info)),
            ]),
          ],
        ),
      ],
    );
  }
}
