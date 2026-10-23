import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';

class FinancialHeroCard extends StatelessWidget {
  final double availableBalance;
  final double monthlyIncome;
  final double monthlyExpense;
  final double totalInvested;
  final String currencySymbol;

  const FinancialHeroCard({
    super.key,
    required this.availableBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    this.totalInvested = 0.0,
    this.currencySymbol = '₹',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryGradient = isDark ? DesignColors.primaryGradientDark : DesignColors.primaryGradientLight;
    final netSavings = (monthlyIncome - monthlyExpense);
    final spendingPower = (availableBalance > 0) ? availableBalance : (monthlyIncome - monthlyExpense).clamp(0.0, double.infinity);

    return GlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Financial Net Position',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (netSavings >= 0 ? DesignColors.positiveGreenDark : DesignColors.errorDark)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        netSavings >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                        size: 14,
                        color: netSavings >= 0 ? DesignColors.positiveGreenDark : DesignColors.errorDark,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '$currencySymbol${netSavings.abs().toStringAsFixed(0)} ${netSavings >= 0 ? "Saved" : "Deficit"}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: netSavings >= 0 ? DesignColors.positiveGreenDark : DesignColors.errorDark,
                            fontFamily: 'Poppins',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ShaderMask(
            shaderCallback: (bounds) => primaryGradient.createShader(bounds),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '$currencySymbol${spendingPower.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          Text(
            'Available Spending Power',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.indigo).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _HeroColumnItem(
                    label: 'Income',
                    value: '+$currencySymbol${monthlyIncome.toStringAsFixed(0)}',
                    color: DesignColors.positiveGreenDark,
                    isDark: isDark,
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                ),
                Expanded(
                  child: _HeroColumnItem(
                    label: 'Expense',
                    value: '-$currencySymbol${monthlyExpense.toStringAsFixed(0)}',
                    color: DesignColors.errorDark,
                    isDark: isDark,
                  ),
                ),
                if (totalInvested > 0) ...[
                  Container(
                    width: 1,
                    height: 32,
                    color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                  ),
                  Expanded(
                    child: _HeroColumnItem(
                      label: 'Invested',
                      value: '$currencySymbol${totalInvested.toStringAsFixed(0)}',
                      color: DesignColors.secondaryDark,
                      isDark: isDark,
                    ),
                  ),
                ],
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
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 3),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}
