import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        ? DesignColors.surfaceInputDark
        : DesignColors.surfaceInputLight;

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
            color: isDark ? Colors.black.withValues(alpha: 0.12) : Colors.indigo.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            color: isDark ? Colors.white38 : Colors.black38,
            fontSize: 14,
            fontWeight: FontWeight.w400,
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
            borderSide: BorderSide(color: borderColor, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: DesignRadius.full,
            borderSide: BorderSide(color: borderColor, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: DesignRadius.full,
            borderSide: BorderSide(color: focusColor, width: 1.8),
          ),
        ),
      ),
    );
  }
}


