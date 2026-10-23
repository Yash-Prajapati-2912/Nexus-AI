import 'package:flutter/material.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_header.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_card.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_table.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_badge.dart';

class AdminFilesPage extends StatelessWidget {
  const AdminFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const AdminHeader(
          category: 'MEDIA & DOCUMENTS',
          title: 'Storage Quota & File Browser',
        ),
        const Row(
          children: [
            Expanded(
              child: AdminCard(
                title: 'Total Cloud Storage',
                value: '4.82 TB',
                subtitle: 'S3 & Local Storage bucket',
                icon: Icons.cloud,
                color: Colors.cyan,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: AdminCard(
                title: 'Stored Media Objects',
                value: '840,000',
                subtitle: 'PDFs, Images, Audio Clips',
                icon: Icons.insert_drive_file,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        AdminTable(
          title: 'Recent Uploaded Files',
          columns: const [
            AdminTableColumn(title: 'File ID'),
            AdminTableColumn(title: 'Filename'),
            AdminTableColumn(title: 'Size'),
            AdminTableColumn(title: 'Owner'),
            AdminTableColumn(title: 'Scanner'),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text('file-901')),
              DataCell(Text('Physics_Quantum_Notes.pdf')),
              DataCell(Text('14.2 MB')),
              DataCell(Text('alex.morgan@university.edu')),
              DataCell(AdminBadge(label: 'CLEAN', status: BadgeStatus.success)),
            ]),
            DataRow(cells: [
              DataCell(Text('file-902')),
              DataCell(Text('Financial_Budgets_2026.xlsx')),
              DataCell(Text('2.1 MB')),
              DataCell(Text('student2@harvard.edu')),
              DataCell(AdminBadge(label: 'CLEAN', status: BadgeStatus.success)),
            ]),
          ],
        ),
      ],
    );
  }
}
