import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final String? iconName;
  final String? colorHex;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.label,
    this.iconName,
    this.colorHex,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color chipColor = theme.colorScheme.primary;

    if (colorHex != null && colorHex!.startsWith('#')) {
      try {
        final hexStr = colorHex!.replaceAll('#', '');
        chipColor = Color(int.parse('FF$hexStr', radix: 16));
      } catch (_) {}
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : chipColor.withAlpha(30),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: chipColor.withAlpha(120), width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconData(iconName),
              size: 16,
              color: isSelected ? Colors.white : chipColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String? name) {
    switch (name) {
      case 'fastfood':
      case 'food':
        return Icons.fastfood_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'transit':
      case 'transport':
        return Icons.directions_bus_rounded;
      case 'school':
      case 'education':
        return Icons.school_rounded;
      case 'work':
      case 'salary':
        return Icons.work_rounded;
      case 'savings':
        return Icons.savings_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
