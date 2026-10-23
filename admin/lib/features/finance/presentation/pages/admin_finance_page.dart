import 'package:flutter/material.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_header.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_card.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_table.dart';
import 'package:nexus_ai_admin/shared/widgets/admin_badge.dart';

class AdminFinancePage extends StatelessWidget {
  const AdminFinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const AdminHeader(
          category: 'FINANCE & REVENUE',
          title: 'Subscriptions & Transaction Metrics',
        ),
        const Row(
          children: [
            Expanded(
              child: AdminCard(
                title: 'Gross Revenue (YTD)',
                value: '\$1,480,000',
                subtitle: '+22.5% YoY',
                icon: Icons.payments,
                color: Colors.green,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: AdminCard(
                title: 'Active Premium Subscribers',
                value: '14,200',
                subtitle: 'Student & Institutional tiers',
                icon: Icons.card_membership,
                color: Colors.teal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        AdminTable(
          title: 'Recent Platform Transactions',
          columns: const [
            AdminTableColumn(title: 'Transaction ID'),
            AdminTableColumn(title: 'User Email'),
            AdminTableColumn(title: 'Plan Tier'),
            AdminTableColumn(title: 'Amount'),
            AdminTableColumn(title: 'Status'),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text('tx-88192')),
              DataCell(Text('student1@mit.edu')),
              DataCell(Text('PREMIUM_ANNUAL')),
              DataCell(Text('\$99.00')),
              DataCell(AdminBadge(label: 'PAID', status: BadgeStatus.success)),
            ]),
            DataRow(cells: [
              DataCell(Text('tx-88193')),
              DataCell(Text('student2@harvard.edu')),
              DataCell(Text('PREMIUM_MONTHLY')),
              DataCell(Text('\$9.99')),
              DataCell(AdminBadge(label: 'PAID', status: BadgeStatus.success)),
            ]),
          ],
        ),
      ],
    );
  }
}
