import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/design_tokens/colors.dart';
import '../../theme/design_tokens/radius.dart';

/// 2026 Reusable Modern Form TextField with Dual-Theme support.
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.enabled = true,
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

    final focusColor = isDark
        ? DesignColors.primaryDark
        : DesignColors.primaryLight;

    final iconColor = isDark
        ? DesignColors.textSecondaryDark
        : DesignColors.textSecondaryLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: DesignRadius.md,
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withValues(alpha: 0.12) : Colors.indigo.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
            enabled: enabled,
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
              errorText: errorText,
              prefixIcon: prefixIcon != null
                  ? IconTheme(
                      data: IconThemeData(color: iconColor, size: 20),
                      child: prefixIcon!,
                    )
                  : null,
              suffixIcon: suffixIcon != null
                  ? IconTheme(
                      data: IconThemeData(color: iconColor, size: 20),
                      child: suffixIcon!,
                    )
                  : null,
              filled: true,
              fillColor: fillColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: DesignRadius.md,
                borderSide: BorderSide(color: borderColor, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: DesignRadius.md,
                borderSide: BorderSide(color: borderColor, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: DesignRadius.md,
                borderSide: BorderSide(color: focusColor, width: 1.8),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: DesignRadius.md,
                borderSide: BorderSide(color: isDark ? DesignColors.errorDark : DesignColors.errorLight, width: 1.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


