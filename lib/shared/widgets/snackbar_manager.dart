import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 2026 Modern Floating Toast & SnackBar Manager helper.
abstract class SnackBarManager {
  static void showSuccess(BuildContext context, String message) {
    _showCustomToast(
      context: context,
      message: message,
      icon: Icons.check_circle_rounded,
      backgroundColor: const Color(0xFF10B981),
    );
  }

  static void showError(BuildContext context, String message) {
    _showCustomToast(
      context: context,
      message: message,
      icon: Icons.error_outline_rounded,
      backgroundColor: const Color(0xFFEF4444),
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showCustomToast(
      context: context,
      message: message,
      icon: Icons.info_outline_rounded,
      backgroundColor: const Color(0xFF6366F1),
    );
  }

  static void showWarning(BuildContext context, String message) {
    _showCustomToast(
      context: context,
      message: message,
      icon: Icons.warning_amber_rounded,
      backgroundColor: const Color(0xFFF59E0B),
    );
  }

  static void _showCustomToast({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        elevation: 6,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
