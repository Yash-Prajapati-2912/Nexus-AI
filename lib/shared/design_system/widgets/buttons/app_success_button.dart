import 'package:flutter/material.dart';
import '../../tokens/colors/semantic_colors.dart';
import '../../tokens/radius/app_radius.dart';

class AppSuccessButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AppSuccessButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: SemanticColors.success,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: DesignRadiusTokens.md),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
