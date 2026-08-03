import 'package:flutter/material.dart';
import '../../theme/design_tokens/colors.dart';
import '../../theme/design_tokens/radius.dart';

/// 2026 Reusable Frosted Custom Form TextField with Glow & Dual-Theme support.
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
        ? DesignColors.glassSurfaceDark
        : DesignColors.glassSurfaceLight;

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
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: DesignRadius.lg,
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.15) : Colors.indigo.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
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
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: isDark ? Colors.white38 : Colors.black38,
                fontSize: 14,
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              border: OutlineInputBorder(
                borderRadius: DesignRadius.lg,
                borderSide: BorderSide(color: borderColor, width: 1.2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: DesignRadius.lg,
                borderSide: BorderSide(color: borderColor, width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: DesignRadius.lg,
                borderSide: BorderSide(color: focusColor, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: DesignRadius.lg,
                borderSide: BorderSide(color: isDark ? DesignColors.errorDark : DesignColors.errorLight, width: 1.2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

