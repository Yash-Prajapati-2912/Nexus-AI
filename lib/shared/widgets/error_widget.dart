import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/design_tokens/colors.dart';
import '../../theme/design_tokens/radius.dart';

/// 2026 Reusable Error Display Widget with Retry Trigger and Dual-Theme support.
class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = isDark ? DesignColors.errorDark : DesignColors.errorLight;
    final textColor = isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: errorColor.withValues(alpha: 0.12),
                border: Border.all(
                  color: errorColor.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              child: Icon(Icons.error_outline_rounded, size: 48, color: errorColor),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: textColor,
                height: 1.45,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text('Retry', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                style: FilledButton.styleFrom(
                  backgroundColor: errorColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: const RoundedRectangleBorder(borderRadius: DesignRadius.md),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


