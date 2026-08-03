import 'package:flutter/material.dart';
import '../../theme/design_tokens/colors.dart';
import '../../theme/design_tokens/radius.dart';

/// 2026 Reusable Search Input Field widget with Dual-Theme support.
class SearchField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final String hint;

  const SearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onClear,
    this.hint = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fillColor = isDark
        ? DesignColors.glassSurfaceDark
        : DesignColors.glassSurfaceLight;

    final borderColor = isDark
        ? DesignColors.glassBorderDark
        : DesignColors.glassBorderLight;

    final iconColor = isDark
        ? DesignColors.textSecondaryDark
        : DesignColors.textSecondaryLight;

    final focusColor = isDark
        ? DesignColors.primaryDark
        : DesignColors.primaryLight;

    return Container(
      decoration: BoxDecoration(
        borderRadius: DesignRadius.full,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.15) : Colors.indigo.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: isDark ? Colors.white38 : Colors.black38,
            fontSize: 14,
          ),
          prefixIcon: Icon(Icons.search_rounded, color: iconColor, size: 20),
          suffixIcon: controller != null && controller!.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: iconColor, size: 18),
                  onPressed: () {
                    controller!.clear();
                    if (onClear != null) onClear!();
                  },
                )
              : null,
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: DesignRadius.full,
            borderSide: BorderSide(color: borderColor, width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: DesignRadius.full,
            borderSide: BorderSide(color: borderColor, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: DesignRadius.full,
            borderSide: BorderSide(color: focusColor, width: 2.0),
          ),
        ),
      ),
    );
  }
}

