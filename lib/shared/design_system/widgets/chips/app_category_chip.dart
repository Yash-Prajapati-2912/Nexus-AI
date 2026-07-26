import 'package:flutter/material.dart';

class AppCategoryChip extends StatelessWidget {
  final String category;
  final IconData? icon;

  const AppCategoryChip({
    super.key,
    required this.category,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: icon != null ? Icon(icon, size: 16) : null,
      label: Text(category),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
