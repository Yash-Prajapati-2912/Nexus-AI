import 'package:flutter/material.dart';
import '../../../../theme/design_tokens/colors.dart';

/// 2026 Reusable Authentication Navigation Footer with Dual-Theme styling.
class AuthFooter extends StatelessWidget {
  final String text;
  final String actionLabel;
  final VoidCallback onActionTap;

  const AuthFooter({
    super.key,
    required this.text,
    required this.actionLabel,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight;
    final actionColor = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextButton(
          onPressed: onActionTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionLabel,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: actionColor,
            ),
          ),
        ),
      ],
    );
  }
}

