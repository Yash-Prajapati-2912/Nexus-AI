import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';

class FinanceSummaryCard extends StatelessWidget {
  final double totalBalance;
  final double incomeTotal;
  final double expenseTotal;

  const FinanceSummaryCard({
    super.key,
    required this.totalBalance,
    required this.incomeTotal,
    required this.expenseTotal,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryGradient = isDark ? DesignColors.primaryGradientDark : DesignColors.primaryGradientLight;

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Net Balance',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 6),
          ShaderMask(
            shaderCallback: (bounds) => primaryGradient.createShader(bounds),
            child: Text(
              '\$${totalBalance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.04) : Colors.indigo.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? DesignColors.glassBorderDark : DesignColors.glassBorderLight,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _MetricItem(
                    label: 'Monthly Income',
                    value: '+\$${incomeTotal.toStringAsFixed(2)}',
                    icon: Icons.arrow_upward_rounded,
                    color: const Color(0xFF10B981),
                    isDark: isDark,
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: isDark ? DesignColors.glassBorderDark : DesignColors.glassBorderLight,
                ),
                Expanded(
                  child: _MetricItem(
                    label: 'Monthly Expense',
                    value: '-\$${expenseTotal.toStringAsFixed(2)}',
                    icon: Icons.arrow_downward_rounded,
                    color: Colors.redAccent,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight;
    final subColor = isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: subColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

