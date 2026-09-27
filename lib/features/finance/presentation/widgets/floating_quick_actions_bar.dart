import 'package:flutter/material.dart';

class FloatingQuickActionsBar extends StatelessWidget {
  final VoidCallback onAddExpense;
  final VoidCallback onAddIncome;
  final VoidCallback onBudgets;
  final VoidCallback onSavings;
  final VoidCallback onInvestments;
  final VoidCallback onAnalytics;

  const FloatingQuickActionsBar({
    super.key,
    required this.onAddExpense,
    required this.onAddIncome,
    required this.onBudgets,
    required this.onSavings,
    required this.onInvestments,
    required this.onAnalytics,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            // Prominent Action — Add Expense
            _PrimaryActionChip(
              icon: Icons.add_circle_outline_rounded,
              label: '+ Expense',
              gradientColors: const [Color(0xFFEF4444), Color(0xFFDC2626)],
              shadowColor: const Color(0xFFEF4444).withValues(alpha: 0.35),
              onTap: onAddExpense,
            ),
            const SizedBox(width: 10),

            // Prominent Action — Add Income
            _PrimaryActionChip(
              icon: Icons.account_balance_wallet_rounded,
              label: '+ Income',
              gradientColors: const [Color(0xFF10B981), Color(0xFF059669)],
              shadowColor: const Color(0xFF10B981).withValues(alpha: 0.35),
              onTap: onAddIncome,
            ),
            const SizedBox(width: 10),

            // Quick Nav Chip — Budget
            _GlassActionChip(
              icon: Icons.pie_chart_rounded,
              label: 'Budget',
              accentColor: const Color(0xFFA78BFA),
              bgColor: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
              borderColor: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
              onTap: onBudgets,
            ),
            const SizedBox(width: 10),

            // Quick Nav Chip — Savings
            _GlassActionChip(
              icon: Icons.savings_rounded,
              label: 'Savings',
              accentColor: const Color(0xFFFBBF24),
              bgColor: const Color(0xFFF59E0B).withValues(alpha: 0.15),
              borderColor: const Color(0xFFF59E0B).withValues(alpha: 0.4),
              onTap: onSavings,
            ),
            const SizedBox(width: 10),

            // Quick Nav Chip — Investments
            _GlassActionChip(
              icon: Icons.show_chart_rounded,
              label: 'Investments',
              accentColor: const Color(0xFF38BDF8),
              bgColor: const Color(0xFF0284C7).withValues(alpha: 0.15),
              borderColor: const Color(0xFF0284C7).withValues(alpha: 0.4),
              onTap: onInvestments,
            ),
            const SizedBox(width: 10),

            // Quick Nav Chip — Analytics
            _GlassActionChip(
              icon: Icons.insights_rounded,
              label: 'Analytics',
              accentColor: const Color(0xFF22D3EE),
              bgColor: const Color(0xFF06B6D4).withValues(alpha: 0.15),
              borderColor: const Color(0xFF06B6D4).withValues(alpha: 0.4),
              onTap: onAnalytics,
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradientColors;
  final Color shadowColor;
  final VoidCallback onTap;

  const _PrimaryActionChip({
    required this.icon,
    required this.label,
    required this.gradientColors,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final Color bgColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _GlassActionChip({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.bgColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: accentColor, size: 17),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
