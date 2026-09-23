import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';

class FinancialHeroCard extends StatelessWidget {
  final double availableBalance;
  final double monthlyIncome;
  final double monthlyExpense;
  final String currencySymbol;

  const FinancialHeroCard({
    super.key,
    required this.availableBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    this.currencySymbol = '₹',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryGradient = isDark ? DesignColors.primaryGradientDark : DesignColors.primaryGradientLight;
    final netSavings = (monthlyIncome - monthlyExpense).clamp(0.0, double.infinity);

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Financial Position',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_upward_rounded, size: 12, color: Color(0xFF10B981)),
                    const SizedBox(width: 4),
                    Text(
                      '$currencySymbol${netSavings.toStringAsFixed(0)} net saved',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ShaderMask(
            shaderCallback: (bounds) => primaryGradient.createShader(bounds),
            child: Text(
              '$currencySymbol${availableBalance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
          Text(
            'Available Net Balance',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withAlpha(10) : Colors.indigo.withAlpha(8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? DesignColors.glassBorderDark : DesignColors.glassBorderLight,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _HeroColumnItem(
                    label: 'Income',
                    value: '+$currencySymbol${monthlyIncome.toStringAsFixed(0)}',
                    color: const Color(0xFF10B981),
                    isDark: isDark,
                  ),
                ),
                Container(width: 1, height: 36, color: isDark ? DesignColors.glassBorderDark : DesignColors.glassBorderLight),
                Expanded(
                  child: _HeroColumnItem(
                    label: 'Expense',
                    value: '-$currencySymbol${monthlyExpense.toStringAsFixed(0)}',
                    color: Colors.redAccent,
                    isDark: isDark,
                  ),
                ),
                Container(width: 1, height: 36, color: isDark ? DesignColors.glassBorderDark : DesignColors.glassBorderLight),
                Expanded(
                  child: _HeroColumnItem(
                    label: 'Saved',
                    value: '$currencySymbol${netSavings.toStringAsFixed(0)}',
                    color: Colors.indigoAccent,
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

class _HeroColumnItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _HeroColumnItem({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight;
    final subColor = isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight;

    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: subColor)),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
          ),
        ),
      ],
    );
  }
}
