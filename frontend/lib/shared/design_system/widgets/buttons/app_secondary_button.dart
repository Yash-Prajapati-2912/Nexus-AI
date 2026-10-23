import 'package:flutter/material.dart';
import '../../tokens/radius/app_radius.dart';

class AppSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? leadingIcon;

  const AppSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: DesignRadiusTokens.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[leadingIcon!, const SizedBox(width: 8)],
            Text(label),
          ],
        ),
      ),
    );
  }
}
