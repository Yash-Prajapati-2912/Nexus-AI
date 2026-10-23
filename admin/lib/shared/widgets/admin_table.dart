import 'package:flutter/material.dart';

class AdminTableColumn {
  final String title;
  final double? width;

  const AdminTableColumn({required this.title, this.width});
}

class AdminTable extends StatelessWidget {
  final List<AdminTableColumn> columns;
  final List<DataRow> rows;
  final String? title;
  final Widget? actionWidget;

  const AdminTable({
    super.key,
    required this.columns,
    required this.rows,
    this.title,
    this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null || actionWidget != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (actionWidget != null) actionWidget!,
                ],
              ),
              const SizedBox(height: 16),
            ],
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  theme.colorScheme.surfaceContainerHighest,
                ),
                columns: columns
                    .map(
                      (col) => DataColumn(
                        label: SizedBox(
                          width: col.width,
                          child: Text(
                            col.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                rows: rows,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
