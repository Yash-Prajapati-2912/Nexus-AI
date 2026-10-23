import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/design_tokens/colors.dart';
import '../../theme/design_tokens/radius.dart';

/// 2026 Reusable Confirmation Dialog helper with Dual-Theme support.
abstract class DialogBase {
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? DesignColors.surfaceElevatedDark : DesignColors.surfaceElevatedLight;
    final titleColor = isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight;
    final bodyColor = isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight;
    final primaryColor = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;

    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: DesignRadius.lg,
            side: BorderSide(
              color: isDark ? DesignColors.glassBorderDark : DesignColors.glassBorderLight,
              width: 1.0,
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.45,
              fontWeight: FontWeight.w400,
              color: bodyColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelLabel,
                style: GoogleFonts.poppins(
                  color: bodyColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                shape: const RoundedRectangleBorder(borderRadius: DesignRadius.md),
              ),
              child: Text(
                confirmLabel,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}


