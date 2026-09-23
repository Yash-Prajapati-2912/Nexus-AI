import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/expense.dart';

class SpendingDonutChartWidget extends StatefulWidget {
  final List<Expense> expenses;
  final String currencySymbol;

  const SpendingDonutChartWidget({
    super.key,
    required this.expenses,
    this.currencySymbol = '₹',
  });

  @override
  State<SpendingDonutChartWidget> createState() => _SpendingDonutChartWidgetState();
}

class _SpendingDonutChartWidgetState extends State<SpendingDonutChartWidget> {
  int _touchedIndex = -1;

  final List<Color> _palette = [
    const Color(0xFFEF4444),
    const Color(0xFF3B82F6),
    const Color(0xFFF59E0B),
    const Color(0xFF10B981),
    const Color(0xFF8B5CF6),
    const Color(0xFFEC4899),
    const Color(0xFF06B6D4),
    const Color(0xFF6B7280),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Group expenses by category
    final Map<String, double> categoryTotals = {};
    double totalSpent = 0.0;

    for (var exp in widget.expenses) {
      final name = exp.categoryName.isNotEmpty ? exp.categoryName : 'General';
      categoryTotals[name] = (categoryTotals[name] ?? 0.0) + exp.amount;
      totalSpent += exp.amount;
    }

    final entries = categoryTotals.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));

    if (totalSpent <= 0 || entries.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Spending Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                height: 160,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withAlpha(5) : Colors.black.withAlpha(5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text('No spending records for this period.', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Spending Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              _touchedIndex = -1;
                              return;
                            }
                            _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 4,
                      centerSpaceRadius: 60,
                      sections: List.generate(entries.length, (i) {
                        final isTouched = i == _touchedIndex;
                        final radius = isTouched ? 30.0 : 22.0;
                        final entry = entries[i];
                        final color = _palette[i % _palette.length];
                        final pct = ((entry.value / totalSpent) * 100).toStringAsFixed(0);

                        return PieChartSectionData(
                          color: color,
                          value: entry.value,
                          title: isTouched ? '${entry.key}\n$pct%' : '',
                          radius: radius,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${widget.currencySymbol}${totalSpent.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Total Spent',
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Category legend grid
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: List.generate(entries.length, (i) {
                final entry = entries[i];
                final color = _palette[i % _palette.length];
                final pct = ((entry.value / totalSpent) * 100).toStringAsFixed(1);

                return InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${entry.key}: ${widget.currencySymbol}${entry.value.toStringAsFixed(2)} ($pct%)')),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text(
                          '${entry.key} $pct%',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
