import 'package:flutter/material.dart';
import '../../theme/design_tokens/colors.dart';

/// 2026 Reusable Modal Bottom Sheet helper with Dual-Theme support.
abstract class BottomSheetBase {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? DesignColors.surfaceDark : DesignColors.surfaceLight;
    final handleColor = isDark ? Colors.white30 : Colors.black26;
    final titleColor = isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight;

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: handleColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              if (title != null) ...[
                const SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Flexible(child: SingleChildScrollView(child: child)),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

