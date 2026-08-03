import 'package:flutter/material.dart';
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
    final backgroundColor = isDark ? DesignColors.surfaceDark : DesignColors.surfaceLight;
    final titleColor = isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight;
    final bodyColor = isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight;
    final primaryColor = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;

    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: DesignRadius.xl,
            side: BorderSide(
              color: isDark ? DesignColors.glassBorderDark : DesignColors.glassBorderLight,
              width: 1.2,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: titleColor,
              letterSpacing: -0.3,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: bodyColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelLabel,
                style: TextStyle(
                  color: bodyColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                shape: const RoundedRectangleBorder(borderRadius: DesignRadius.lg),
              ),
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );
  }
}

